require 'spec_helper'

describe Level do
  let!(:level) { build :level }
  describe '#create' do
    context 'When creating an invalid Level' do
      context 'with no level' do
        before :each do
          level.level = nil
        end
        it 'is invalid' do
          expect(level.valid?).to be false
        end
        it 'contains an error' do
          expect(level.errors[:level]).not_to be_nil
        end
      end
      context 'with no title' do
        before :each do
          level.title = nil
        end
        it 'is not valid' do
          expect(level.valid?).to be false
        end
        it 'contains an error' do
          expect(level.errors[:title]).not_to be_nil
        end
      end
      context 'with no from' do
        before :each do
          level.from = nil
        end
        it 'is not valid' do
          expect(level.valid?).to be false
        end
        it 'contains an error' do
          expect(level.errors[:from]).not_to be_nil
        end
      end
      context 'with no to' do
        before :each do
          level.to = nil
        end
        it 'is not valid' do
          expect(level.valid?).to be false
        end
        it 'contains an error' do
          expect(level.errors[:to]).not_to be_nil
        end
      end
      context 'with invalid range ( to < from )' do
        before :each do
          level.from =  Faker::Number.number(3)
          level.to = level.from - Faker::Number.number(2).to_i
        end
        it 'is not valid' do
          expect(level.valid?).to be false
        end
        it 'contains an error' do
          expect(level.errors[:to]).not_to be_nil
        end
      end
      context 'with invalid range ( to = from )' do
        before :each do
          level.from =  Faker::Number.number(3)
          level.to = level.from
        end
        it 'is not valid' do
          expect(level.valid?).to be false
        end
        it 'contains an error' do
          expect(level.errors[:to]).not_to be_nil
        end
      end
    end
  end
end
