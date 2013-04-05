require 'dcell'
require 'stuff-classifier'

DCell.start :id => "classify", :addr => "tcp://127.0.0.1:9001"

class Classify
  include Celluloid

  def initialize
    @storage =  StuffClassifier::FileStorage.new("#{Dir.pwd}/data/trained.data")
    @classifier = {}
  end

  def create_store(classifier_name)
    @classifier[classifier_name] = StuffClassifier::Bayes.new(classifier_name, storage: @storage)
    true
  end

  def classify(classifier_name, data)
    @classifier[classifier_name].classify(data)
  end

  def train(classifier_name, type, data)
    @classifier[classifier_name].train(type, data)
  end

  def save_training(classifier_name)
    @classifier[classifier_name].save_state
  end

end

Classify.supervise_as :classify
sleep
