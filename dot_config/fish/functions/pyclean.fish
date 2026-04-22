
function pyclean   --description '__pycache__ cleaner'
    find . -regex '^.*\(__pycache__\|\.py[co]\)$' -delete
end

