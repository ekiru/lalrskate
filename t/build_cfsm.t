#!/usr/bin/env winxed

function main[main]() {
    load_bytecode("rosella/test.pbc");
    load_bytecode("lalr.pbc");
    using Rosella.Test.test;
    test(class BuildCFSMTest);
}

class BuildCFSMTest {
    function test_example_from_practical_7_1() {
	using LALR.DPDA.EPSILON;
	using LALR.Generator.build_CFSM;
	using LALR.Generator.BuildCFSM.hash_state_for;
	var grammar = new LALR.Grammar;
	grammar.add_nonterminal("E");
	grammar.add_nonterminal("T");
	grammar.add_terminal("+");
	grammar.add_terminal("t");
	grammar.start("E");

	grammar.add_rule("E", "E", "+", "T");
	grammar.add_rule("T", "t");

	var cfsm = build_CFSM(grammar);
	var state = cfsm.start();
//	self.assert.equal(cfsm_state_for("E"), state);

	var transitions = cfsm.transitions_from(state);
	int i = transitions;
	self.assert.equal(2, transitions);

	var transition = transitions[0];
	self.assert.is_true(transition instanceof LALR.DPDA.ReadTransition);
	self.assert.equal(EPSILON(), transition.symbol());
	self.assert.equal(state, transition.to());

	transition = transitions[1];
	self.assert.is_true(transition instanceof LALR.DPDA.ReadTransition);
	self.assert.equal("E", transition.symbol());

	state = transition.to();
	transitions = cfsm.transitions_from(state);
	self.assert.equal(1, transitions);

	transition = transitions[0];
	self.assert.is_true(transition instanceof LALR.DPDA.ReadTransition);
	self.assert.equal("+", transition.symbol());

	state = transition.to();
	transitions = cfsm.transitions_from(state);
	self.assert.equal(2, transitions);
	
	transition = transitions[0];
	self.assert.is_true(transition instanceof LALR.DPDA.ReadTransition);
	self.assert.equal(EPSILON(), transition.symbol());

	transition = transitions[1];
	self.assert.is_true(transition instanceof LALR.DPDA.ReadTransition);
	self.assert.equal("T", transition.symbol());

	state = transition.to();
	transitions = cfsm.transitions_from(state);
	self.assert.equal(1, transitions);
	transition = transitions[0];
	self.assert.is_true(transition instanceof LALR.DPDA.ReadTransition);
	self.assert.equal(hash_state_for("E", 0), transition.symbol());
	self.assert.equal(0, cfsm.transitions_from(transition.to()));
    }

}