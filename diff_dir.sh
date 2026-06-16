# FUTURE OPTIONS: 
# sudo apt-get install colordiff
# Code
# colordiff -r $1 $2
# 🔥 If you want a sync-style diff (best for large trees)
# Code
# rsync -avun --delete $1/ $2/
# Shows added, removed, changed files

#
# $1 - Local From Directory1 
# $2 - Directory1 comparison 
#
# i.e Diff_Directory $STEVE/3d_web/ /tmp/clone
#
Diff_Directory()
{
for f in `ls $1`
do
   bn=`basename $f`
   echo "$1/$f $2/$bn "
   diff -qr $1/$f $2/$bn
done
}

# diff -qr /tmp/steve/3d_web /tmp/clone
Diff_Directory /tmp/3d-web /var/www/3dlifestrategies.org/html

echo 
echo "NEXT:"
diff -qr /tmp/3d-web /var/www/3dlifestrategies.org/html

