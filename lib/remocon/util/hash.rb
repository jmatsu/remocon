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
      if v.kind_of?(Hash)
        v.stringify_values
      elsif v.kind_of?(Array)
        v.stringify_values
      else
        v.to_s
      end
    end
  end
end
