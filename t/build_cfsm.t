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
    
    // This test case comes from G_0, where it wasn't initially working.
    function test_A_to_c_A_and_A_to_d() {
	using LALR.DPDA.EPSILON;
	using LALR.Generator.build_CFSM;
	using LALR.Generator.BuildCFSM.hash_state_for;

	var grammar = new LALR.Grammar;
	grammar.add_nonterminal("A");
	grammar.add_terminal("c");
	grammar.add_terminal("d");

	grammar.start("A");

	grammar.add_rule("A", "c", "A");
	grammar.add_rule("A", "d");

	var cfsm = build_CFSM(grammar);

	var state = cfsm.start();
	var transitions = cfsm.transitions_from(state);
	self.assert.equal(2, transitions);
    }

    function test_no_ambiguity_for_shared_prefixes() {
	using LALR.Generator.build_CFSM;
	var grammar = new LALR.Grammar;
	grammar.add_terminal('+');
	grammar.add_terminal('1');
	grammar.add_terminal('0');
	grammar.add_nonterminal('S');
	grammar.start('S');
	grammar.add_rule('S', '+', '1');
	grammar.add_rule('S', '+', '0');

	var cfsm = build_CFSM(grammar);

	self.assert.equal(1, elements(cfsm.transitions_from(cfsm.start())));

	var transition = cfsm.transitions_from(cfsm.start())[0];
	self.assert.is_true(transition instanceof LALR.DPDA.ReadTransition);
	self.assert.equal('+', transition.symbol());

    }

}