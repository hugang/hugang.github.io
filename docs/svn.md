# SVN



## 使用方法

### 1.create a repository
svnadmin create svntest

### 2.create trunk
svn mkdir file:///home/hg/svntest/trunk -m "add trunk"

### 3.add or modify files in trunk
svn co file:///home/hg/svntest/trunk
cd trunk
echo "hello,world" > hello.txt
svn add hello.txt
svn commit -m "add hello.txt"

### 4.create branches from trunk and modify
svn copy --parents file:///home/hg/svntest/trunk file:///home/hg/svntest/branches/deva -m "add branch a"
svn copy --parents file:///home/hg/svntest/trunk file:///home/hg/svntest/branches/devb -m "add branch b"
svn co file:///home/hg/svntest/branches/deva
...
svn co file:///home/hg/svntest/branches/devb
...

### 5.merge from branch to trunk
cd trunk
svn update
svn merge file:///home/hg/svntest/branches/deva /home/hg/trunk
svn commit -m "merge from branch a"

### 6.solve conflicted files
export SVN_EDITOR=vim
svn merge file:///home/hg/svntest/branches/devb /home/hg/trunk
...e)dit and save
svn commit -m "merge from branch b"

### 7.delete merged branches
svn del file:///home/hg/svntest/branches/deva -m "branch a merge completed"
svn del file:///home/hg/svntest/branches/devb -m "branch b merge completed"