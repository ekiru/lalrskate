#!/usr/bin/env winxed

function main[main]() {
    load_bytecode("rosella/test.pbc");
    load_bytecode("lalr.pbc");
    using Rosella.Test.test;
    test(class ExplicitlyPushTest);
}

class ExplicitlyPushTest {
    function test_transitionless() {
	var dpda = new LALR.DPDA;
	dpda.add_state("1", 1);
	dpda.start("1");

	using LALR.Generator.explicitly_push_states;
	explicitly_push_states(dpda);

	self.assert.equal(2, elements(dpda.states()));
	self.assert.equal(1, elements(dpda.transitions_from("1")));
	self.assert.is_true(dpda.transitions_from("1")[0] instanceof LALR.DPDA.PushTransition);
	self.assert.equal("1", dpda.transitions_from("1")[0].symbol());

	string new_state = dpda.transitions_from("1")[0].to();
	self.assert.equal(0, elements(dpda.transitions_from(new_state)));
    }

    function test_single_transition() {
	var dpda = new LALR.DPDA;
	dpda.add_state("1", 1);
	dpda.add_state("2");
	dpda.start("1");

	var transition = new LALR.DPDA.ReadTransition;
	transition.to("2");
	transition.symbol("a");
	dpda.add_transition_from("1", transition);

	using LALR.Generator.explicitly_push_states;
	explicitly_push_states(dpda);

	self.assert.equal(3, dpda.states());

	self.assert.equal(1, elements(dpda.transitions_from("1")));
	transition = dpda.transitions_from("1")[0];
	self.assert.is_true(transition instanceof LALR.DPDA.PushTransition);
	self.assert.equal("1", transition.symbol());

	var state = transition.to();
	self.assert.equal(1, elements(dpda.transitions_from(state)));
	transition = dpda.transitions_from(state)[0];
	self.assert.is_true(transition instanceof LALR.DPDA.ReadTransition);
	self.assert.equal("a", transition.symbol());
	self.assert.equal("2", transition.to());

	self.assert.equal(0, elements(dpda.transitions_from("2")));
    }
}