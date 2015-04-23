
#ifndef Earing_Tuner_h
#define Earing_Tuner_h



class Tuner {
public:
	Tuner(unsigned secondsStepBetweenRowsFromBas, unsigned numberOfStrings) {
		for(unsigned i=0; i< numberOfStrings; ++i)
			secondsBetweenRowsFromBas_.push_back(secondsStepBetweenRowsFromBas);
	}
	Tuner(unsigned baseFrequency, std::vector<int> secondsBetweenRowsFromBas) {
		setTuning(baseFrequency, secondsBetweenRowsFromBas_);
	}
	
	unsigned getFrequencyFromPosition(unsigned positionX, unsigned positionY) {
		/* Note: position (row,string==0,column,fret==0) is the lowest frequency note*/
		if(positionY > secondsBetweenRowsFromBas_.size())
			throw int();
		unsigned frequencyIndex = 0;
		for(unsigned i=0; i < positionY; ++i)
			frequencyIndex += secondsBetweenRowsFromBas_[i];
		return (frequencyIndex+positionX);
	}
	void setTuning(unsigned baseFrequency, const std::vector<int> secondsBetweenRowsFromBas) {
		baseFrequency_ = baseFrequency;
		secondsBetweenRowsFromBas_ = secondsBetweenRowsFromBas;
	}
	
	std::vector<int> getSth (unsigned stringIndexFromBottom) {
		std::vector<int> result;
		
		for(unsigned i = 0; i < secondsBetweenRowsFromBas_.size(); ++i) {
			int sresult = 0;
			if(i <  stringIndexFromBottom) {
				for(unsigned j = i; j < stringIndexFromBottom; ++j) {
					sresult += secondsBetweenRowsFromBas_[j];
				}
			}
			if(i == stringIndexFromBottom) {
				sresult = 0;
			}
			if(i >  stringIndexFromBottom) {
				for(unsigned j = stringIndexFromBottom; j < i; ++j) {
					sresult -= secondsBetweenRowsFromBas_[j];
				}
			}
			result.push_back(sresult);
		}
		
		return result;
	}
	
private:
	unsigned baseFrequency_;
	std::vector<int> secondsBetweenRowsFromBas_;
};

#endif
