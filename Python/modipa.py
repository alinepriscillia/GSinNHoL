# -*- coding: UTF-8 -*-

import re

# Feature system taken from Hayes 2008 (pp. 95-98)

ipa_to_features = {}


all_features = ['consonantal', 'sonorant', 'syllabic', 'labial', 'round', 'coronal', 'anterior', 'distributed', 'dorsal', 'high', 'low', 'front', 'back', 'tense', 'pharyngeal', 'ATR',  'voice', 'spread.gl', 'constr.gl','continuant', 'strident', 'lateral', 'delayed.release', 'nasal', 'diphthong']

#the diphthong feature is one that has been added for the sake of simply representing all the vowels present in the audiobooks


##############
# Consonants #
##############

consonant_features = ['consonantal', 'sonorant', 'syllabic', 'labial', 'round', 'coronal', 'anterior', 'distributed', 'dorsal', 'high', 'low', 'front', 'back', 'tense', 'pharyngeal', 'ATR',  'voice', 'spread.gl', 'constr.gl','continuant', 'strident', 'lateral', 'delayed.release', 'nasal', 'diphthong']
#same as all but there's a bug in the code if I don't do the if condition for the features


# labial obstruents
ipa_to_features[u'p'] = {'consonantal': True, 'sonorant': False, 'syllabic': False, 'labial': True, 'round': False, 'coronal': False, 'anterior': None, 'distributed': None, 'dorsal': False, 'high': None, 'low': None, 'front': None, 'back': None, 'tense': None, 'pharyngeal': False, 'ATR': None, 'voice': False, 'spread.gl': False, 'constr.gl': False, 'continuant': False, 'strident': False, 'lateral': False, 'delayed.release': False, 'nasal': False, 'diphthong': None}
ipa_to_features[u'b'] = {'consonantal': True, 'sonorant': False, 'syllabic': False, 'labial': True, 'round': False, 'coronal': False, 'anterior': None, 'distributed': None, 'dorsal': False, 'high': None, 'low': None, 'front': None, 'back': None, 'tense': None, 'pharyngeal': False, 'ATR': None, 'voice': True, 'spread.gl': False, 'constr.gl': False, 'continuant': False, 'strident': False, 'lateral': False, 'delayed.release': False, 'nasal': False, 'diphthong': None}
ipa_to_features[u'f'] = {'consonantal': True, 'sonorant': False, 'syllabic': False, 'labial': True, 'round': False, 'coronal': False, 'anterior': None, 'distributed': None, 'dorsal': False, 'high': None, 'low': None, 'front': None, 'back': None, 'tense': None, 'pharyngeal': False, 'ATR': None, 'voice': False, 'spread.gl': False, 'constr.gl': False, 'continuant': True, 'strident': True, 'lateral': False, 'delayed.release': False, 'nasal': False, 'diphthong': None}
ipa_to_features[u'v'] = {'consonantal': True, 'sonorant': False, 'syllabic': False, 'labial': True, 'round': False, 'coronal': False, 'anterior': None, 'distributed': None, 'dorsal': False, 'high': None, 'low': None, 'front': None, 'back': None, 'tense': None, 'pharyngeal': False, 'ATR': None, 'voice': True, 'spread.gl': False, 'constr.gl': False, 'continuant': True, 'strident': True, 'lateral': False, 'delayed.release': False, 'nasal': False, 'diphthong': None}

# coronal obstruents
ipa_to_features[u't'] = {'consonantal': True, 'sonorant': False, 'syllabic': False, 'labial': False, 'round': None, 'coronal': True, 'anterior': True, 'distributed': False, 'dorsal': False, 'high': None, 'low': None, 'front': None, 'back': None, 'tense': None, 'pharyngeal': False, 'ATR': None, 'voice': False, 'spread.gl': False, 'constr.gl': False, 'continuant': False, 'strident': False, 'lateral': False, 'delayed.release': False, 'nasal': False, 'diphthong': None}
ipa_to_features[u'd'] = {'consonantal': True, 'sonorant': False, 'syllabic': False, 'labial': False, 'round': None, 'coronal': True, 'anterior': True, 'distributed': False, 'dorsal': False, 'high': None, 'low': None, 'front': None, 'back': None, 'tense': None, 'pharyngeal': False, 'ATR': None, 'voice': True, 'spread.gl': False, 'constr.gl': False, 'continuant': False, 'strident': False, 'lateral': False, 'delayed.release': False, 'nasal': False, 'diphthong': None}
ipa_to_features[u's'] = {'consonantal': True, 'sonorant': False, 'syllabic': False, 'labial': False, 'round': None, 'coronal': True, 'anterior': True, 'distributed': False, 'dorsal': False, 'high': None, 'low': None, 'front': None, 'back': None, 'tense': None, 'pharyngeal': False, 'ATR': None, 'voice': False, 'spread.gl': False, 'constr.gl': False, 'continuant': True, 'strident': True, 'lateral': False, 'delayed.release': False, 'nasal': False, 'diphthong': None}
ipa_to_features[u'z'] = {'consonantal': True, 'sonorant': False, 'syllabic': False, 'labial': False, 'round': None, 'coronal': True, 'anterior': True, 'distributed': False, 'dorsal': False, 'high': None, 'low': None, 'front': None, 'back': None, 'tense': None, 'pharyngeal': False, 'ATR': None, 'voice': True, 'spread.gl': False, 'constr.gl': False, 'continuant': True, 'strident': True, 'lateral': False, 'delayed.release': False, 'nasal': False, 'diphthong': None}

#liquids and nasals
ipa_to_features[u'm'] = {'consonantal': True, 'sonorant': True, 'syllabic': False, 'labial': True, 'round': False, 'coronal': False, 'anterior': None, 'distributed': None, 'dorsal': False, 'high': None, 'low': None, 'front': None, 'back': None, 'tense': None, 'pharyngeal': False, 'ATR': None, 'voice': True, 'spread.gl': False, 'constr.gl': False, 'continuant': False, 'strident': False, 'lateral': False, 'delayed.release': False, 'nasal': True, 'diphthong': None}
ipa_to_features[u'n'] = {'consonantal': True, 'sonorant': True, 'syllabic': False, 'labial': False, 'round': None, 'coronal': True, 'anterior': True, 'distributed': False, 'dorsal': False, 'high': None, 'low': None, 'front': None, 'back': None, 'tense': None, 'pharyngeal': False, 'ATR': None, 'voice': True, 'spread.gl': False, 'constr.gl': False, 'continuant': False, 'strident': False, 'lateral': False, 'delayed.release': False, 'nasal': True, 'diphthong': None}
ipa_to_features[u'l'] = {'consonantal': True, 'sonorant': True, 'syllabic': False, 'labial': False, 'round': None, 'coronal': True, 'anterior': True, 'distributed': False, 'dorsal': False, 'high': None, 'low': None, 'front': None, 'back': None, 'tense': None, 'pharyngeal': False, 'ATR': None, 'voice': True, 'spread.gl': False, 'constr.gl': False, 'continuant': True, 'strident': False, 'lateral': True, 'delayed.release': False, 'nasal': False, 'diphthong': None}
ipa_to_features[u'r'] = {'consonantal': True, 'sonorant': True, 'syllabic': False, 'labial': False, 'round': None, 'coronal': True, 'anterior': True, 'distributed': False, 'dorsal': False, 'high': None, 'low': None, 'front': None, 'back': None, 'tense': None, 'pharyngeal': False, 'ATR': None, 'voice': True, 'spread.gl': False, 'constr.gl': False, 'continuant': True, 'strident': False, 'lateral': False, 'delayed.release': False, 'nasal': False, 'diphthong': None}
#maybe reinsert a trill feature?


# glides
ipa_to_features[u'j'] = {'consonantal': False, 'sonorant': True, 'syllabic': False, 'labial': False, 'round': False, 'coronal': False, 'anterior': None, 'distributed': None, 'dorsal': True, 'high': True, 'low': False, 'front': False, 'back': False, 'tense': False, 'pharyngeal': False, 'ATR': None, 'voice': True, 'spread.gl': False, 'constr.gl': False, 'continuant': True, 'strident': False, 'lateral': False, 'delayed.release': False, 'nasal': False, 'diphthong': None}
ipa_to_features[u'w'] = {'consonantal': False, 'sonorant': True, 'syllabic': False, 'labial': True, 'round': True, 'coronal': False, 'anterior': None, 'distributed': None, 'dorsal': True, 'high': True, 'low': False, 'front': False, 'back': True, 'tense': False, 'pharyngeal': False, 'ATR': None, 'voice': True, 'spread.gl': False, 'constr.gl': False, 'continuant': True, 'strident': False, 'lateral': False, 'delayed.release': False, 'nasal': False, 'diphthong': None}

# dorsal obstruents
ipa_to_features[u'k'] = {'consonantal': True, 'sonorant': False, 'syllabic': False, 'labial': False, 'round': None, 'coronal': False, 'anterior': None, 'distributed': None, 'dorsal': True, 'high': True, 'low': False, 'front': False, 'back': True, 'tense': False, 'pharyngeal': False, 'ATR': None, 'voice': False, 'spread.gl': False, 'constr.gl': False, 'continuant': False, 'strident': False, 'lateral': False, 'delayed.release': False, 'nasal': False, 'diphthong': None}
ipa_to_features[u'x'] = {'consonantal': True, 'sonorant': False, 'syllabic': False, 'labial': False, 'round': None, 'coronal': False, 'anterior': None, 'distributed': None, 'dorsal': True, 'high': True, 'low': False, 'front': False, 'back': True, 'tense': False, 'pharyngeal': False, 'ATR': None, 'voice': False, 'spread.gl': False, 'constr.gl': False, 'continuant': True, 'strident': False, 'lateral': False, 'delayed.release': False, 'nasal': False, 'diphthong': None}

# laryngeals
ipa_to_features[u'h'] = {'consonantal': False, 'sonorant': False, 'syllabic': False, 'labial': False, 'round': None, 'coronal': False, 'anterior': None, 'distributed': None, 'dorsal': False, 'high': None, 'low': None, 'front': None, 'back': None, 'tense': None, 'pharyngeal': False, 'ATR': None, 'voice': False, 'spread.gl': True, 'constr.gl': False, 'continuant': True, 'strident': False, 'lateral': False, 'delayed.release': False, 'nasal': False, 'diphthong': None}


##########
# Vowels #
##########

vowel_features = ['consonantal', 'sonorant', 'syllabic', 'labial', 'round', 'coronal', 'anterior', 'distributed', 'dorsal', 'high', 'low', 'front', 'back', 'tense', 'pharyngeal', 'ATR',  'voice', 'spread.gl', 'constr.gl','continuant', 'strident', 'lateral', 'delayed.release', 'nasal', 'diphthong']


# high tense
ipa_to_features[u'y'] = {'consonantal': False, 'sonorant': True, 'syllabic': True, 'labial': True, 'round': True, 'coronal': False, 'anterior': None, 'distributed': None, 'dorsal': True, 'high': True, 'low': False, 'front': True, 'back': False, 'tense': True, 'pharyngeal': True, 'ATR': True, 'voice': True, 'spread.gl': False, 'constr.gl': False, 'continuant': True, 'strident': False, 'lateral': False, 'delayed.release': False, 'nasal': False, 'diphthong': False}
ipa_to_features[u'u'] = {'consonantal': False, 'sonorant': True, 'syllabic': True, 'labial': True, 'round': True, 'coronal': False, 'anterior': None, 'distributed': None, 'dorsal': True, 'high': True, 'low': False, 'front': False, 'back': True, 'tense': True, 'pharyngeal': True, 'ATR': True, 'voice': True, 'spread.gl': False, 'constr.gl': False, 'continuant': True, 'strident': False, 'lateral': False, 'delayed.release': False, 'nasal': False, 'diphthong': False}

# high lax
ipa_to_features[u'ɪ'] = {'consonantal': False, 'sonorant': True, 'syllabic': True, 'labial': True, 'round': False, 'coronal': False, 'anterior': None, 'distributed': None, 'dorsal': True, 'high': True, 'low': False, 'front': True, 'back': False, 'tense': False, 'pharyngeal': True, 'ATR': False, 'voice': True, 'spread.gl': False, 'constr.gl': False, 'continuant': True, 'strident': False, 'lateral': False, 'delayed.release': False, 'nasal': False, 'diphthong': False}

# mid tense
ipa_to_features[u'e'] = {'consonantal': False, 'sonorant': True, 'syllabic': True, 'labial': True, 'round': False, 'coronal': False, 'anterior': None, 'distributed': None, 'dorsal': True, 'high': False, 'low': False, 'front': True, 'back': False, 'tense': True, 'pharyngeal': True, 'ATR': True, 'voice': True, 'spread.gl': False, 'constr.gl': False, 'continuant': True, 'strident': False, 'lateral': False, 'delayed.release': False, 'nasal': False, 'diphthong': False}
ipa_to_features[u'o'] = {'consonantal': False, 'sonorant': True, 'syllabic': True, 'labial': True, 'round': True, 'coronal': False, 'anterior': None, 'distributed': None, 'dorsal': True, 'high': False, 'low': False, 'front': False, 'back': True, 'tense': True, 'pharyngeal': True, 'ATR': True, 'voice': True, 'spread.gl': False, 'constr.gl': False, 'continuant': True, 'strident': False, 'lateral': False, 'delayed.release': False, 'nasal': False, 'diphthong': False}

# mid lax
ipa_to_features[u'ɛ'] = {'consonantal': False, 'sonorant': True, 'syllabic': True, 'labial': True, 'round': False, 'coronal': False, 'anterior': None, 'distributed': None, 'dorsal': True, 'high': False, 'low': False, 'front': True, 'back': False, 'tense': False, 'pharyngeal': True, 'ATR': False, 'voice': True, 'spread.gl': False, 'constr.gl': False, 'continuant': True, 'strident': False, 'lateral': False, 'delayed.release': False, 'nasal': False, 'diphthong': False}
ipa_to_features[u'œ'] = {'consonantal': False, 'sonorant': True, 'syllabic': True, 'labial': True, 'round': True, 'coronal': False, 'anterior': None, 'distributed': None, 'dorsal': True, 'high': False, 'low': False, 'front': True, 'back': False, 'tense': False, 'pharyngeal': True, 'ATR': False, 'voice': True, 'spread.gl': False, 'constr.gl': False, 'continuant': True, 'strident': False, 'lateral': False, 'delayed.release': False, 'nasal': False, 'diphthong': False}
ipa_to_features[u'ɔ'] = {'consonantal': False, 'sonorant': True, 'syllabic': True, 'labial': True, 'round': True, 'coronal': False, 'anterior': None, 'distributed': None, 'dorsal': True, 'high': False, 'low': False, 'front': False, 'back': True, 'tense': False, 'pharyngeal': True, 'ATR': False, 'voice': True, 'spread.gl': False, 'constr.gl': False, 'continuant': True, 'strident': False, 'lateral': False, 'delayed.release': False, 'nasal': False, 'diphthong': False}

# low
ipa_to_features[u'a'] = {'consonantal': False, 'sonorant': True, 'syllabic': True, 'labial': True, 'round': False, 'coronal': False, 'anterior': None, 'distributed': None, 'dorsal': True, 'high': False, 'low': True, 'front': False, 'back': False, 'tense': False, 'pharyngeal': True, 'ATR': False, 'voice': True, 'spread.gl': False, 'constr.gl': False, 'continuant': True, 'strident': False, 'lateral': False, 'delayed.release': False, 'nasal': False, 'diphthong': False}
ipa_to_features[u'ɑ'] = {'consonantal': False, 'sonorant': True, 'syllabic': True, 'labial': True, 'round': False, 'coronal': False, 'anterior': None, 'distributed': None, 'dorsal': True, 'high': False, 'low': True, 'front': False, 'back': True, 'tense': False, 'pharyngeal': True, 'ATR': False, 'voice': True, 'spread.gl': False, 'constr.gl': False, 'continuant': True, 'strident': False, 'lateral': False, 'delayed.release': False, 'nasal': False, 'diphthong': False}

# diphthong
ipa_to_features[u'ɛi'] = {'consonantal': False, 'sonorant': True, 'syllabic': True, 'labial': True, 'round': False, 'coronal': False, 'anterior': None, 'distributed': None, 'dorsal': True, 'high': False, 'low': False, 'front': True, 'back': False, 'tense': False, 'pharyngeal': True, 'ATR': False, 'voice': True, 'spread.gl': False, 'constr.gl': False, 'continuant': True, 'strident': False, 'lateral': False, 'delayed.release': False, 'nasal': False, 'diphthong': True}
ipa_to_features[u'œy'] = {'consonantal': False, 'sonorant': True, 'syllabic': True, 'labial': True, 'round': True, 'coronal': False, 'anterior': None, 'distributed': None, 'dorsal': True, 'high': False, 'low': False, 'front': True, 'back': False, 'tense': False, 'pharyngeal': True, 'ATR': False, 'voice': True, 'spread.gl': False, 'constr.gl': False, 'continuant': True, 'strident': False, 'lateral': False, 'delayed.release': False, 'nasal': False, 'diphthong': True}
ipa_to_features[u'ɔu'] = {'consonantal': False, 'sonorant': True, 'syllabic': True, 'labial': True, 'round': True, 'coronal': False, 'anterior': None, 'distributed': None, 'dorsal': True, 'high': False, 'low': False, 'front': False, 'back': True, 'tense': False, 'pharyngeal': True, 'ATR': False, 'voice': True, 'spread.gl': False, 'constr.gl': False, 'continuant': True, 'strident': False, 'lateral': False, 'delayed.release': False, 'nasal': False, 'diphthong': True}



#all_features = set(consonant_features + vowel_features)

value_map = {'+': True, '-': False, '0': None}
reverse_value_map = {True: '+', False: '-', None: '0'}

# Split a combined feature and value into separate parts
# E.g. "+sonorant" -> ("sonorant", True)
def split_feature_and_value(feature):
	if len(feature) < 1:
		return None
	value = feature[0]
	if value not in value_map:
		return None
	value = value_map[value]
	feature = feature[1:]
	if feature not in all_features:
		return None
	return (feature, value)

# combine a feature and a value into one representation
# E.g. ("sonorant", True) -> "+sonorant"
def combine_feature_and_value(feature, value):
	if value not in reverse_value_map:
		return None
	return reverse_value_map[value] + feature

# Note: this may need to change if the feature system is modified
def is_vowel(phoneme):
	return 'consonantal' not in ipa_to_features[phoneme]

def is_consonant(phoneme):
	return not is_vowel(phoneme)

def phoneme_feature_string(phoneme):
	if phoneme not in ipa_to_features:
		return None
	features = all_features
	feature_value_pairs = [(feature, ipa_to_features[phoneme][feature]) for feature in features]
	return ", ".join([combine_feature_and_value(feature, value) for feature, value in feature_value_pairs if value != None])

def get_natural_class(features):
	features = re.findall('\s*([^\s]+)\s*', features, re.UNICODE)
	result = set(ipa_to_features.keys())
	for feature in features:
		matches = set()
		split = split_feature_and_value(feature)
		if split == None:
			print("Invalid feature: " + feature)
			return set()
		feature, value = split
		for phoneme in ipa_to_features:
			feature_values = ipa_to_features[phoneme]
			if feature in feature_values and feature_values[feature] == value:
				matches.add(phoneme)		
		result = result.intersection(matches)
	return result
