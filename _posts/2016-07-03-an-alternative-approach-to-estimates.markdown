---
layout: post
title: "An Alternative Approach to Estimates"
date: 2016-07-03 21:18:13 BST
code-math: true
comments: true
---

## Problem

A while ago I was asked to plan one of the last phases of development on a project that required re-architecture of the data access layer. One of my tasks was to estimate an effort to replace code that communicates with a legacy back-end. The new code, instead of directly connecting to a database should consume JSON-based REST API endpoints. Due to time constraints and to mitigate the risk to bring the service down this change supposed to be done in as non-invasive way as possible.

Objectives

 - Functionality of the application must remain unchanged for the end user

Facts

 - It is a simple MVC application built upon a reach domain model
 - Books like _[Design Patterns](https://www.amazon.co.uk/Design-patterns-elements-reusable-object-oriented/dp/0201633612)_ and _[Clean Code](https://www.amazon.co.uk/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882)_ were probably not that popular at the time of writing the software

Issues

 - Developers' skills in our team differ much
 - Complexity of the code that needs to be refactored varies from module to module
 - We have never done that before

Assumptions

 - We know the product already
 - Most of the code logic and flow remain the same
 - It should take no longer to refactor the code than implementing that functionality from scratch
 - A lot of work is repetitive and follows a pattern

How to take the above factors into account and produce accurate estimates for the management?

## Solution

I was not able to find anyone who faced similar technical problems with the platform we use. This tells me something about our design, anyway... Yes, I heard about [COCOMO II - Constructive Cost Model](http://csse.usc.edu/tools/COCOMOII.php). However, I still decided to come up with my simplistic formula.

&nbsp;&nbsp;
$$\scriptsize
{
    \sum_{i=0}^n componentManDays\_i = totalManDays
}
$$
$$\scriptsize
{
    \frac{linesOfCode\_i}{avgLinesOfCodePerHour \times 6h} \times complexityFactor\_i \times contingency = componentManDays\_i
}
$$
&nbsp;&nbsp;

Why? Because whichever method is used the outcome is always a guesstimate. I found out that **it is so much dependent on motivation of individual team members** as well as their willingness to learn and contribute. This can not be expressed by any mathematical equation.

I usually add 20% contingency to my calculations and set complexity factor to _cf=1_ for a simple code in higher layers of an application architecture, _cf=2_ for components that require more analytical and problem solving skills and up to _cf=3_ for tasks that require attention of a polyglot programmer.

## Automation

After considering a manual approach of producing my estimates for each module and component I decided to automate that process. Quick, and in my opinion relatively reliable solution was to base the calculations on an ability to change number of lines of code by an average developer in our team in a selected period of time. There are number of issues with this approach. For example, **data for the empirical analysis must come from a project with a comparable architecture, technology stack, complexity and codebase**. Fortunately, we have been working on this software already for over a year delivering new functionality. So, all the data I needed were in the version control system... The only thing I needed to do is write a script that does the rest of the work for me.

Here is the usage example followed by some of the Bash functions to help to extract relevant information from Git. I used an open source project to produce the output.

&nbsp;

```shell
$ git_print_stats 1y # for Linux use "1 year"
Developer  1       1                     46 +23:-23
Developer  2       1                     79 +44:-35
Developer  3       0                        0 +0:-0
Developer  4       5                      46 +40:-6
Developer  5       0                        0 +0:-0
Developer  6       1                        2 +1:-1
Developer  7       0                        0 +0:-0
Developer  8       0                        0 +0:-0
Developer  9       0                        0 +0:-0
Developer 10       1                        2 +1:-1
Developer 11       3                       17 +9:-8
Developer 12       2                      61 +57:-4
Developer 13      30                   545 +455:-90
Developer 14      30                   545 +455:-90
Developer 15       4                   117 +101:-16
Developer 16       1                        4 +2:-2
Developer 17       0                        0 +0:-0
Developer 18       1                      15 +13:-2
Developer 19       6                     79 +63:-16
Developer 20       3                       16 +8:-8
$ git_calc_avg_changes_per_dev 1y
78
$ source_count_lines ./module/A *.ext
3595
```

&nbsp;&nbsp;

Calculate average line changes per developer in a given period of time.
{% highlight shell %}
function git_calc_avg_changes_per_dev()
{
    data=$(git_print_stats "$1" --csv | awk -F',' '{ print $3 }')
    sum=0; i=0
    for n in $data; do
        sum=$(($sum + $n)); ((i++))
    done
    echo $(($sum / $i))
}
{% endhighlight %}

Print number of commits and line changes for each individual contributor.
{% highlight shell %}
function git_print_stats()
{
    OLDIFS=$IFS; IFS=$'\n' #'
    for committer in $(git_list_committers); do
        cc=$(git_count_commits "$committer" "$1")
        cl=$(git_count_line_changes "$committer" "$1")
        if [[ $* == *"--csv"* ]]; then
            al=$(echo "$cl" | awk '{ print $1 }')
            dl=$(echo "$cl" | awk '{ print $2 }')
            printf "\"%s\",%s,%s,%s\n" "$committer" "$cc" $al $dl
        else
            printf "%40s %7s %30s\n" "$committer" $cc "$cl"
        fi
    done
    IFS=$OLDIFS
}
{% endhighlight %}

List all contributors.
{% highlight shell %}
function git_list_committers()
{
    git log --all --format='%cN' | sort -u
}
{% endhighlight %}

Return number of commits for a given author.
{% highlight shell %}
function git_count_commits()
{
    git log \
        --author="$1" \
        --since=$(date_ago "$2") \
        --until=$(date +%Y/%m/%d) \
        --no-merges \
        --pretty='%h [%s] <%an>' \
        --abbrev-commit \
    | wc -l | tr -d '[[:space:]]'
}
{% endhighlight %}

Return number of line changes for a given author.
{% highlight shell %}
function git_count_line_changes()
{
    git log \
        --author="$1" \
        --since=$(date_ago "$2") \
        --until=$(date +%Y/%m/%d) \
        --no-merges \
        --pretty='%h [%s] <%an>' \
        --abbrev-commit \
        --numstat \
    | awk 'NF==3 \
        { plus+=$1; minus+=$2; total+=$1+$2 } END \
        { printf("%d +%d:-%d\n", total, plus, minus) }'
}
{% endhighlight %}

Calculate date in the past from now.
{% highlight shell %}
function date_ago()
{
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # 1y, 12m, 52w, 365d, etc.
        date -v-$1 +%Y/%m/%d
    else
        # 1 year, 12 months, 52 weeks, 365 days, etc.
        date +%Y/%m/%d -d "-$1"
    fi
}
{% endhighlight %}

Count recursively all lines in files for a give file type.
{% highlight shell %}
function source_count_lines()
{
    find $1 -name $2 -print0 | xargs -0 cat | wc -l
}
{% endhighlight %}
&nbsp;
