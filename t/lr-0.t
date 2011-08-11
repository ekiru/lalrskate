#!/usr/bin/env winxed

function main[main]() {
    load_bytecode("rosella/test.pbc");
    load_bytecode("lalr.pbc");
    using Rosella.Test.test;
    test(class LR0Test);
}

function g_0() {
    var grammar = new LALR.Grammar;

    grammar.add_nonterminal("S");
    grammar.add_nonterminal("E");
    grammar.add_nonterminal("A");
    grammar.add_nonterminal("B");
    grammar.add_terminal("a");
    grammar.add_terminal("b");
    grammar.add_terminal("c");
    grammar.add_terminal("d");

    grammar.start("S");

    grammar.add_rule("S", "E");

    grammar.add_rule("E", "a", "A");
    grammar.add_rule("A", "c", "A");
    grammar.add_rule("A", "d");

    grammar.add_rule("E", "b", "B");
    grammar.add_rule("B", "c", "B");
    grammar.add_rule("B", "d");	

    return (new LALR.Generator).generate(grammar);
}

class StringActions {
    function terminal_action(terminal, match) {
	match.ast("(t " + string(terminal) + ")");
    }

    function nonterminal_action(name, number, match) {
	string children = "";
	for (var child in match.children()) {
	    children += " " + string(child.ast());
	}
	match.ast("(nt " + string(name) + " " + string(number) + children + ")");
    }
}

class LR0Test {
    function test_g_0() {
	var dpda = g_0();
	var actions = new StringActions;

	var interp = new LALR.DPDA.Interpreter;
	interp.BUILD(dpda:[named("dpda")], actions:[named("actions")]);

	var match = interp.parse(["a", "d"]);
	self.assert.equal("(nt S 0 (nt E 0 (t a) (nt A 1 (t d))))", match.ast());
    }
}