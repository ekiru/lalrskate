#!/usr/bin/env winxed

function main[main]() {
    load_bytecode("rosella/test.pbc");
    load_bytecode("lalr.pbc");
    using Rosella.Test.test;
    test(class DPDATest);
}

class DPDATest {
    function test_straight_line_reads() {
	using LALR.DPDA;
	var dpda = new LALR.DPDA;
	dpda.add_state("1");
	dpda.add_state("2");
	dpda.add_state("3");

	var trans = new LALR.DPDA.ReadTransition;
	trans.to("2");
	trans.symbol("a");
	dpda.add_transition_from("1", trans);

	trans = new LALR.DPDA.ReadTransition;
	trans.to("3");
	trans.symbol("b");
	dpda.add_transition_from("2", trans);

	self.assert.is_true(dpda.is_state("1"));
	self.assert.is_true(dpda.is_state("2"));
	self.assert.is_true(dpda.is_state("3"));

	var transitions = dpda.transitions_from("1");
	self.assert.equal(1, transitions);
	self.assert.equal("2", transitions[0].to());
	self.assert.equal("a", transitions[0].symbol());

	transitions = dpda.transitions_from("2");
	self.assert.equal(1, transitions);
	self.assert.equal("3", transitions[0].to());
	self.assert.equal("b", transitions[0].symbol());

	transitions = dpda.transitions_from("3");
	self.assert.equal(0, transitions);
    }

    function test_branch() {
	var dpda = new LALR.DPDA;
	dpda.add_state("1");
	dpda.add_state("2");
	dpda.add_state("3");

	var transition = new LALR.DPDA.ReadTransition;
	transition.to("2");
	transition.symbol("a");
	dpda.add_transition_from("1", transition);

	transition = new LALR.DPDA.ReadTransition;
	transition.to("3");
	transition.symbol("b");
	dpda.add_transition_from("1", transition);

	self.assert.is_true(dpda.is_state("1"));
	self.assert.is_true(dpda.is_state("2"));
	self.assert.is_true(dpda.is_state("3"));

	var transitions = dpda.transitions_from("1");
	self.assert.equal(2, transitions);
	self.assert.equal("2", transitions[0].to());
	self.assert.equal("a", transitions[0].symbol());
	self.assert.equal("3", transitions[1].to());
	self.assert.equal("b", transitions[1].symbol());

	self.assert.equal(0, dpda.transitions_from("2"));
	self.assert.equal(0, dpda.transitions_from("3"));
    }

    function test_adequacy() {
	using LALR.Generator.BuildCFSM.hash_state_for;
	var dpda = new LALR.DPDA;
	dpda.add_state('1');
	dpda.add_state('2');

	var transition = new LALR.DPDA.ReadTransition;
	dpda.symbol(hash_state_for('A', 0));
	dpda.to('2');
	dpda.add_transition_from('1', transition);

	transition = new LALR.DPDA.ReadTransition;
	dpda.symbol('1');
	dpda.to('2');
	dpda.add_transition_from('1', transition);

	self.assert.is_false(dpda.is_adequate());
    }
}