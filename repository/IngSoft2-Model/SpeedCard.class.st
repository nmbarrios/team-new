Class {
	#name : #SpeedCard,
	#superclass : #PermanentCard,
	#category : #'IngSoft2-Model'
}

{ #category : #moving }
SpeedCard >> affectDiceRoll: aRoll [
	^ aRoll + 1
]

{ #category : #applying }
SpeedCard >> applyIn: aMatch to: aPlayer [
	aMatch add: self toBeAppliedTo: aPlayer.
	aMatch updateLastCard: self.
	
]

{ #category : #applying }
SpeedCard >> redoIn: aMatch to: aPlayer by: aRedoCard [
	aMatch add: aRedoCard toBeAppliedTo: aPlayer.
	aMatch updateLastCard: aRedoCard
]
