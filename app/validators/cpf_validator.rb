class CpfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if record.cpf.blank?

    record.errors.add(attribute, :invalid) unless cpf_checker(value)
    record.errors.add(attribute, :unpermitted_chars) unless format_checker(value)
    record.errors.add(attribute, :out_of_range) unless value.length == 11
  end

  def format_checker(cpf)
    cpf.match?(/\A\d{11}\z/)
  end

  def cpf_checker(cpf)
    return false if (cpf.count(cpf.chr) == 11) | (cpf == '12345678909')

    original = cpf.chars.map(&:to_i)
    computed = original[0..-3]

    2.times { computed << make_a_digit(computed) }

    original[-2..] == computed[-2..]
  end

  private

  def make_a_digit(base)
    products = base.dup
                   .zip((2..base.size + 1).reverse_each)
                   .map { |pair_digit_weight| pair_digit_weight.inject(:*) }

    mod = products.sum % 11
    mod < 2 ? 0 : (11 - mod)
  end
end
