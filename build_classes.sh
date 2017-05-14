cd classes
git pull
make rst

cd ..
rm page/classes/class_*
cp classes/_build/rst/* page/classes -f
