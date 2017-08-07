require 'rails_helper'

RSpec.describe GameRecord, :type => :model do
  let(:game_record) { GameRecord.create(num_rows: 6, num_cols: 7) }
  before {
    @board = [['-', '-', '-', '-', '-', '-'],
              ['-', '-', '-', '-', '-', '-'],
              ['-', '-', '-', '-', '-', '-'],
              ['-', '-', 'red', 'blue', 'blue', 'red', '-'],
              ['-', '-', 'red', 'blue', 'red', 'blue', '-'],
              ['-', 'blue', 'red', 'red', 'red', 'blue', 'blue']]
            }

  describe '#horizontal_score' do
    it 'scores board as 0' do
      score = game_record.horizontal_score(@board)
      expect(score).to eq(0)
    end
  end

  describe '#vertical_score' do
    it 'scores board as 98' do
      score = game_record.vertical_score(@board)
      expect(score).to eq(98)
    end
  end

  describe '#diag_up_right_score' do
    it 'scores board as -100' do
      score = game_record.diag_up_right_score(@board)
      expect(score).to eq(-100)
    end
  end

  describe '#diag_down_left_score' do
    it 'scores board as 92' do
      score = game_record.diag_down_left_score(@board)
      expect(score).to eq(92)
    end
  end

  describe '#score_set_of_four' do
    context 'with a set of four matching AI slots only' do
      it 'scores set as 1000' do
        score = game_record.score_set_of_four(%w[red red red red])
        expect(score).to eq(1000)
      end
    end

    context 'with a set of four matching opponent slots only' do
      it 'scores set as -1000' do
        score = game_record.score_set_of_four(%w[blue blue blue blue])
        expect(score).to eq(-1000)
      end
    end

    context 'with a set of three matching AI slots only' do
      it 'scores set as 100' do
        score = game_record.score_set_of_four(%w[red red red])
        expect(score).to eq(100)
      end
    end

    context 'with a set of three matching opponent slots only' do
      it 'scores set as -100' do
        score = game_record.score_set_of_four(%w[blue blue blue])
        expect(score).to eq(-100)
      end
    end

    context 'with a set of two matching AI slots only' do
      it 'scores set as 10' do
        score = game_record.score_set_of_four(%w[red red])
        expect(score).to eq(10)
      end
    end

    context 'with a set of two matching opponent slots only' do
      it 'scores set as -10' do
        score = game_record.score_set_of_four(%w[blue blue])
        expect(score).to eq(-10)
      end
    end

    context 'with one AI slot only' do
      it 'scores set as 1' do
        score = game_record.score_set_of_four(%w[red])
        expect(score).to eq(1)
      end
    end

    context 'with mix of slots' do
      it 'scores set as 0' do
        score = game_record.score_set_of_four(%w[red red blue blue])
        expect(score).to eq(0)
      end
    end
  end
end
