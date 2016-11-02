# laravel by dreipro

## Locations

* [github repo](https://github.com/dreipro/laravel)
* [dockerhub repo](https://hub.docker.com/r/dreipro/laravel/)

## Howto

Work on master branch. Then rebase php-5.6 branch on master:

``` bash
 $ git checkout php-5.6
 $ git rebase master
 
 # maybe fix merge issue and do a git add (no git commit) 
 # and continue with git rebase --continue
 
 $ git push -f 
 $ git checkout master
```


## Appendix

``` bash
# install the defined dependencies for the project
$ composer install

# if composer.lock exists fetch the latest matching versions
$ composer update
```


## Links

* [Composer](https://getcomposer.org/doc/00-intro.md) - Composer is a tool for dependency management in PHP. It is not a package manager in the same sense as Yum or Apt are. Instead it manages "packages" or library dependencies on a per-project basis, installing them in a directory (e.g. vendor) inside your project.

* [PSRs](http://www.php-fig.org/psr/)
  * [Coding Guidelines in PSR-1](http://www.php-fig.org/psr/psr-1/) and [PSR-2](http://www.php-fig.org/psr/psr-2/)

* Testing in PHP
  * [PhpUnit](https://phpunit.de/)
  * [PhpSpec](http://www.phpspec.net/en/stable/manual/getting-started.html)
  * [Speciphy](https://github.com/speciphy/speciphy)

  * [Behat - Cucumber in PHP](http://behat.org/en/latest/)


* Other docker laravel stuff
  * [mtmacdonald/docker-laravel](https://github.com/mtmacdonald/docker-laravel)
  * [LaraDock/laradock](https://github.com/LaraDock/laradock)
  * [Dylan Lindgren - Docker for the Laravel Framework](http://dylanlindgren.com/docker-for-the-laravel-framework/)
