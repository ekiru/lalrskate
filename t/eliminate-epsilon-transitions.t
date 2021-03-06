function main[main]() {
    load_bytecode("rosella/test.pbc");
    load_bytecode("lalr.pbc");
    using Rosella.Test.test;
    test(class EpsilonEliminationTest);
}

class EpsilonEliminationTest {

    function test_e_prime() {
	using LALR.DPDA.EPSILON;
	using LALR.Generator.eliminate_epsilon_transitions;
	var dpda = new LALR.DPDA;
	dpda.add_state("E'");
	dpda.add_state("1");
	dpda.add_state("2");
	dpda.add_state("T'");
	dpda.add_state("3");
	dpda.add_state("4");
	dpda.add_state("End");

	var transition = new LALR.DPDA.ReadTransition;
	transition.to("1");
	transition.symbol("E");
	dpda.add_transition_from("E'", transition);

	transition = new LALR.DPDA.ReadTransition;
	transition.to("E'");
	transition.symbol(EPSILON());
	dpda.add_transition_from("E'", transition);

	transition = new LALR.DPDA.ReadTransition;
	transition.to("2");
	transition.symbol("+");
	dpda.add_transition_from("1", transition);

	transition = new LALR.DPDA.ReadTransition;
	transition.to("3");
	transition.symbol("T");
	dpda.add_transition_from("2", transition);

	transition = new LALR.DPDA.ReadTransition;
	transition.to("T'");
	transition.symbol(EPSILON());
	dpda.add_transition_from("2", transition);

	transition = new LALR.DPDA.ReadTransition;
	transition.to("End");
	transition.symbol("#_1");
	dpda.add_transition_from("3", transition);

	transition = new LALR.DPDA.ReadTransition;
	transition.to("4");
	transition.symbol("a");
	dpda.add_transition_from("T'", transition);

	eliminate_epsilon_transitions(dpda);

	var transitions = dpda.transitions_from("2");
	self.assert.equal(2, elements(transitions));
	var T_trans;
	var a_trans;
	for (transition in transitions) {
	    self.assert.not_equal(transition.to(), "T'");
	    self.assert.is_true(transition instanceof LALR.DPDA.ReadTransition);
	    if (string(transition.to()) == "3") {
		T_trans = transition;
	    } else if (string(transition.to()) == "4") {
		a_trans = transition;
	    } else {
		self.assert.is_true(0);
	    }
	}

	self.assert.equal("T", T_trans.symbol());
	self.assert.equal("a", a_trans.symbol());
    }

    function test_does_not_create_ambiguity() {
	using LALR.DPDA.EPSILON;
	using LALR.Generator.eliminate_epsilon_transitions;
	var dpda = new LALR.DPDA;
	dpda.add_state('0');
	dpda.add_state('1');
	dpda.add_state('2');
	dpda.add_state('3');
	dpda.add_state('4');

	var transition = new LALR.DPDA.ReadTransition;
	transition.to('1');
	transition.symbol('+');
	dpda.add_transition_from('0', transition);

	transition = new LALR.DPDA.ReadTransition;
	transition.to('2');
	transition.symbol(EPSILON());
	dpda.add_transition_from('0', transition);

	transition = new LALR.DPDA.ReadTransition;
	transition.to('3');
	transition.symbol('+');
	dpda.add_transition_from('2', transition);

	transition = new LALR.DPDA.ReadTransition;
	transition.to('4');
	transition.symbol('1');
	dpda.add_transition_from('1', transition);

	transition = new LALR.DPDA.ReadTransition;
	transition.to('4');
	transition.symbol('3');
	dpda.add_transition_from('3', transition);

	eliminate_epsilon_transitions(dpda);

	self.assert.equal(1, elements(dpda.transitions_from('0')));
	self.assert.equal(2, elements(dpda.transitions_from(dpda.transitions_from('0')[0].to())));
    }

    function test_transitive_epsilon_elimination() {
	using LALR.DPDA.EPSILON;
	using LALR.Generator.eliminate_epsilon_transitions;
	var dpda = new LALR.DPDA;
	dpda.add_state('0');
	dpda.add_state('1');
	dpda.add_state('2');
	dpda.add_state('3');
	dpda.add_state('4');

	var transition = new LALR.DPDA.ReadTransition;
	transition.symbol(EPSILON());
	transition.to('1');
	dpda.add_transition_from('0', transition);

	transition = new LALR.DPDA.ReadTransition;
	transition.symbol('1');
	transition.to('2');
	dpda.add_transition_from('1', transition);

	transition = new LALR.DPDA.ReadTransition;
	transition.symbol(EPSILON());
	transition.to('3');
	dpda.add_transition_from('1', transition);

	transition = new LALR.DPDA.ReadTransition;
	transition.symbol('3');
	transition.to('4');
	dpda.add_transition_from('3', transition);

	eliminate_epsilon_transitions(dpda);

	self.assert.equal(2, elements(dpda.transitions_from('0')));
    }

}
