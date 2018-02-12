use v6.c;
unit class App::Mi6::Release::GitCommit;

method run(*%opt) {
    if %*ENV<FAKE_RELEASE> {
        note "Skip GitCommit because FAKE_RELEASE is set.";
        return;
    }

    my $message = "Bump version to " ~ %opt<next-version>;
    my $proc;
    $proc = run <git commit -a -m>, $message;
    die if $proc.exitcode != 0;

    my $branch = self!git-branch;
    $proc = run <git push origin>, $branch;
    die if $proc.exitcode != 0;
}

method !git-branch {
    my $content = ".git/HEAD".IO.slurp(:close);
    if $content ~~ rx{ 'ref: refs/heads/' (\S+) } {
        return $/[0]
    } else {
        "master";
    }
}
