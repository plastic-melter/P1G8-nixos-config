{colorscheme}:
with colorscheme.colors; let
in ''
* {
    all: unset;
    font-family: "NotoSansCJK:style=Bold";
    font-size: 32px;
}

#window {
    background-color: rgba(1, 1, 1, 0);
    border-radius: 0px;
    border: 0px solid #aaaab0
}

#outer-box {
    background-color: rgba(1, 1, 1, 0);
    border: 0px solid #999999;
    border-radius: 20px;
}

#scroll {
    border: 6px solid #ccc2ff;
    margin: 1rem;
    border-radius: 10px;
    background-color: #181b28;
}

#input{
    margin: 1rem 8rem 1rem 8rem;
    border: 6px solid #ccc2ff;
    border-radius: 10px;
    padding: 0.5rem 1rem 0.5rem 1rem;
    background-color: #181b28;
}

#entry {
    margin: 0.25rem 0.75rem 0.25rem 0.75rem;
    padding: 0.25rem 0.75rem 0.25rem 0.75rem;
    color: #ffffd8;
    border-radius: 8px;
}

#entry:selected {
    color: #89fc00;
    font-weight: bold;
}

''
