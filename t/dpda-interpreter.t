#!/usr/bin/env winxed

function main[main]() {
    load_bytecode("rosella/test.pbc");
    load_bytecode("lalr.pbc");
    using Rosella.Test.test;
    test(class InterpreterTest);
}

class InterpreterTest {
    function test_read_transitions() {
        var dpda = new LALR.DPDA;
        dpda.add_state("1");
        dpda.add_state("2");
	dpda.start("1");
        var transition = new LALR.DPDA.ReadTransition;
        transition.to("2");
        transition.symbol("a");
        dpda.add_transition_from("1", transition);
        var interp = new LALR.DPDA.Interpreter;
        interp.BUILD(dpda:[named("dpda")]);

	interp.feed_input("a");
	interp.perform_transition();
	self.assert.equal("2", interp.state());
	self.assert.is_false(interp.error_occurred());

	interp = new LALR.DPDA.Interpreter;
	interp.BUILD(dpda:[named("dpda")]);

	interp.feed_input("b");
	interp.perform_transition();
	self.assert.is_true(interp.error_occurred());
    }

    function test_push_and_top_transitions() {
	var dpda = new LALR.DPDA;
	dpda.add_state("1");
	dpda.add_state("2");
	dpda.add_state("31");
	dpda.add_state("32");

	dpda.start("1");
	var transition = new LALR.DPDA.PushTransition;
	transition.symbol("a");
	transition.to("2");
	dpda.add_transition_from("1", transition);

	transition = new LALR.DPDA.TopTransition;
	transition.expected("b");
	transition.to("31");
	dpda.add_transition_from("2", transition);

	transition = new LALR.DPDA.TopTransition;
	transition.expected("a");
	transition.to("32");
	dpda.add_transition_from("2", transition);

	var interp = new LALR.DPDA.Interpreter;
	interp.BUILD(dpda:[named("dpda")]);

	interp.perform_transition();
	self.assert.is_false(interp.error_occurred());
	self.assert.equal("2", interp.state());

	interp.perform_transition();
	self.assert.is_false(interp.error_occurred());
	self.assert.equal("32", interp.state());
    }
}