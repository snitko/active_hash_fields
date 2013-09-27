active_hash_fields
======

*An ActiveRecord extension to add serialized hash fields that act like objects*

Usecase
------------------------
A `User` should be able to set various notification options for various events. For example, he may want to receive an email notification when someone leaves a comment for his blog post, but not when someone replies with a comment to his comment.

This can usually be solved by either creating an additional associated model like `NotificationSettings` or by creating numerous fields in the `User` model itself. Not quite efficient either way.

Usage
------------------------

Here's the solution:

    class User < ActiveRecord::Base

      active_hash_fields :notitications,
        comments_to_my_posts:    true,
        comments_to_my_comments: false,
        someone_friended_me:     true,
        new_private_message:     true    

    end


Now you can do things like:

    # Default values are the ones set in the model,
    # here we just redefine one
    user = User.new(notifications: { comments_to_my_posts: false })

    user.notifications.comments_to_my_posts # => false
    user.notifications.new_private_message  # => true


IMPORTANT NOTE! If you don't set a default value for the field, it will be ignored, that is:

    user.notifications.some_non_existent_field = true
    user.notifications.some_non_existent_field # => nil


INSTALLATION
------------

	  gem install active_hash_fields
