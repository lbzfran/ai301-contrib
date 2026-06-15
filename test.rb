# typed: true
require 'sorbet-runtime'
require 'singleton'

extend T::Sig

class A < T::Struct
  class Unset
    include Singleton
  end

  prop :foo, T.any(T.nilable(Integer), Unset), default: Unset.instance
end

A.new
