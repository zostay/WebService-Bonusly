# NAME

WebService::Bonusly - A handy library for accessing the Bonus.ly API

# VERSION

version 1.001

# SYNOPSIS

    use WebService::Bonusly;
    my $bonusly = WebService::Bonusly->new( token => $token );
        
    $res = $bonusly->authentication->sessions(
        email => '...',
        password => '...',
    );
        
    $res = $bonusly->bonuses->get( id => '...' );
    $res = $bonusly->bonuses->give( reason => '...' );
    $res = $bonusly->bonuses->list;
        
    $res = $bonusly->companies->show;
    $res = $bonusly->companies->update;
        
    $res = $bonusly->leaderboards->standouts;
        
    $res = $bonusly->redemptions->get( id => '...' );
        
    $res = $bonusly->rewards->get( id => '...' );
    $res = $bonusly->rewards->list;
        
    $res = $bonusly->users->add(
        email => '...',
        first_name => '...',
        last_name => '...',
    );
    $res = $bonusly->users->autocomplete( search => '...' );
    $res = $bonusly->users->bonuses( id => '...' );
    $res = $bonusly->users->create_redemption(
        id => '...',
        denomination_id => '...',
    );
    $res = $bonusly->users->delete( id => '...' );
    $res = $bonusly->users->get( id => '...' );
    $res = $bonusly->users->list;
    $res = $bonusly->users->me;
    $res = $bonusly->users->neighborhood( id => '...' );
    $res = $bonusly->users->redemptions( id => '...' );
    $res = $bonusly->users->update( id => '...' );
        
    $res = $bonusly->values->get( id => '...' );
    $res = $bonusly->values->list;

# DESCRIPTION

This is a fairly simple library for performing actions with the Bonus.ly API.

# ERRORS

Normally bonusly will return `{ success => 0, message => $reason }` when
there are errors, but on the off chance that something went really wrong,
`WebService::Bonusly` will synthesize a data structure like this:

    {
        success => 0,
        message => 'Not Found',
        status => 404,
        content => "<html>...",
        response_object => HTTP::Response->new(...),
    }

When handling errors, you **may** want to consider checking if there is a
`response_object` and logging its contents somewhere.

# ATTRIBUTES

## token

This is the access token to use to perform actions with.

## debug

This is a boolean flag that, when set to true, causes messages to be printed to STDERR about what is being sent to and received from bonus.ly. 

This is done through calls to the `print_debug` method.

## authentication

This provides methods for accessing the Authentication aspects of the API. This provides the following methods:

### sessions

    $res = $bonusly->authentication->sessions(%params);

Performs a POST against `/api/v1/sessions` at bonus.ly.

Required Parameters: `email`, `password`

## bonuses

This provides methods for accessing the Bonuses aspects of the API. This provides the following methods:

### get

    $res = $bonusly->bonuses->get(%params);

Performs a GET against `/api/v1/bonuses/:id` at bonus.ly.

Required Parameters: `id`

### give

    $res = $bonusly->bonuses->give(%params);

Performs a POST against `/api/v1/bonuses` at bonus.ly.

Required Parameters: `reason`

Optional Parameters: `giver_email`, `parent_bonus_id`, `receiver_email`, `amount`

### list

    $res = $bonusly->bonuses->list(%params);

Performs a GET against `/api/v1/bonuses` at bonus.ly.

Optional Parameters: `limit`, `skip`, `start_time`, `end_time`, `non_zero`, `top_level`, `giver_email`, `receiver_email`, `user_email`, `hashtag`, `include_children`

## companies

This provides methods for accessing the Companies aspects of the API. This provides the following methods:

### show

    $res = $bonusly->companies->show;

Performs a GET against `/api/v1/companies/show` at bonus.ly.

### update

    $res = $bonusly->companies->update(%params);

Performs a PUT against `/api/v1/companies/update` at bonus.ly.

Optional Parameters: `name`, `custom_properties`

The `custom_properties` parameter must be given a reference to a hash.

## leaderboards

This provides methods for accessing the Leaderboards aspects of the API. This provides the following methods:

### standouts

    $res = $bonusly->leaderboards->standouts(%params);

Performs a GET against `/api/v1/analytics/standouts` at bonus.ly.

Optional Parameters: `role`, `value`, `limit`, `period`, `custom_property_name`, `custom_property_value`

## redemptions

This provides methods for accessing the Redemptions aspects of the API. This provides the following methods:

### get

    $res = $bonusly->redemptions->get(%params);

Performs a GET against `/api/v1/redemptions/:id` at bonus.ly.

Required Parameters: `id`

## rewards

This provides methods for accessing the Rewards aspects of the API. This provides the following methods:

### get

    $res = $bonusly->rewards->get(%params);

Performs a GET against `/api/v1/rewards/:id` at bonus.ly.

Required Parameters: `id`

### list

    $res = $bonusly->rewards->list(%params);

Performs a GET against `/api/v1/rewards` at bonus.ly.

Optional Parameters: `catalog_country`, `request_country`, `personalize_for`

## users

This provides methods for accessing the Users aspects of the API. This provides the following methods:

### add

    $res = $bonusly->users->add(%params);

Performs a POST against `/api/v1/users` at bonus.ly.

Required Parameters: `email`, `first_name`, `last_name`

Optional Parameters: `custom_properties`, `user_mode`, `budget_boost`, `external_unique_id`

The `custom_properties` parameter must be given a reference to a hash.

### autocomplete

    $res = $bonusly->users->autocomplete(%params);

Performs a GET against `/api/v1/users/autocomplete` at bonus.ly.

Required Parameters: `search`

### bonuses

    $res = $bonusly->users->bonuses(%params);

Performs a GET against `/api/v1/users/:id/bonuses` at bonus.ly.

Required Parameters: `id`

Optional Parameters: `skip`, `start_time`, `hashtag`, `end_time`, `include_children`, `limit`, `role`

### create\_redemption

    $res = $bonusly->users->create_redemption(%params);

Performs a POST against `/api/v1/users/:id/redemptions` at bonus.ly.

Required Parameters: `id`, `denomination_id`

### delete

    $res = $bonusly->users->delete(%params);

Performs a DELETE against `/api/v1/users/:id` at bonus.ly.

Required Parameters: `id`

### get

    $res = $bonusly->users->get(%params);

Performs a GET against `/api/v1/users/:id` at bonus.ly.

Required Parameters: `id`

### list

    $res = $bonusly->users->list(%params);

Performs a GET against `/api/v1/users` at bonus.ly.

Optional Parameters: `limit`, `skip`, `email`, `sort`

### me

    $res = $bonusly->users->me;

Performs a GET against `/api/v1/users/me` at bonus.ly.

### neighborhood

    $res = $bonusly->users->neighborhood(%params);

Performs a GET against `/api/v1/users/:id/neighborhood` at bonus.ly.

Required Parameters: `id`

Optional Parameters: `days`

### redemptions

    $res = $bonusly->users->redemptions(%params);

Performs a GET against `/api/v1/users/:id/redemptions` at bonus.ly.

Required Parameters: `id`

Optional Parameters: `limit`, `skip`

### update

    $res = $bonusly->users->update(%params);

Performs a PUT against `/api/v1/users/:id` at bonus.ly.

Required Parameters: `id`

Optional Parameters: `email`, `first_name`, `last_name`, `custom_properties`, `user_mode`, `budget_boost`, `external_unique_id`

The `custom_properties` parameter must be given a reference to a hash.

## values

This provides methods for accessing the Values aspects of the API. This provides the following methods:

### get

    $res = $bonusly->values->get(%params);

Performs a GET against `/api/v1/values/:id` at bonus.ly.

Required Parameters: `id`

### list

    $res = $bonusly->values->list;

Performs a GET against `/api/v1/values` at bonus.ly.

# DEVELOPMENT

If you are interested in helping develop this library. Please check it out from github. See [https://github.com/zostay/WebService-Bonusly](https://github.com/zostay/WebService-Bonusly). The library is automatically generated from a script named `apigen.pl`. To build the library you will need to install [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla) and run:

    dzil authordeps | cpanm
    dzil build

Instead of running the "dzil build" command you may also run:

    ./apigen.pl

The templates for generating the code are found in `tmpl`.

# AUTHOR

Andrew Sterling Hanenkamp <hanenkamp@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Qubling Software LLC.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
