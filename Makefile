.PHONY: fetch run test

# make fetch SLUG=two-sum [LANGS=elixir,python]
fetch:
	@scripts/lc.sh fetch $(SLUG) $(if $(LANGS),--langs $(LANGS))

# make run FILE=problems/0001-two-sum/solution.ex [SUBMIT=1]
run:
	@scripts/lc.sh run $(FILE) $(if $(SUBMIT),--submit)

# make test SLUG=two-sum
test:
	@elixir scripts/run_tests.exs $(SLUG)
