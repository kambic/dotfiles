function y
    set tmp (mktemp)
    yazi --cwd-file=$tmp $argv
    if test -f $tmp
        set cwd (cat $tmp)
        rm $tmp
        if test -d $cwd
            cd $cwd
        end
    end
end
