# frozen_string_literal: true

class Hash
  def skip_nil_values
    dup.compact.each_with_object({}) do |(k, v), acc|
      next unless v
      acc[k] = case v
               when Hash
                 v.skip_nil_values
               when Array
                 v.compact
               else
                 v
               end
    end
  end

  def stringify_values
    self.deep_merge(self) do |_, _, v|
      if v.is_a?(Hash)
        v.stringify_values
      elsif v.is_a?(Array)
        v.map(&:stringify_values)
      else
        v.to_s
      end
    end
  end
end
