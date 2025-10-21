# Tumblr Ruby Gem

[![Gem Version](https://badge.fury.io/rb/tumblr_client.png)](https://badge.fury.io/rb/tumblr_client)

This is the official Ruby wrapper for the Tumblr v2 API. It supports all endpoints currently available on
the [Tumblr API](https://www.tumblr.com/docs/en/api/v2).

## Table of Contents

- [AI Assistant Use Disclaimer](#ai-assistant-use-disclaimer)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
  - [Configuration](#configuration)
  - [The Console](#the-console)
  - [Creating a Client](#creating-a-client)
- [API Methods](#api-methods)
  - [User Methods](#user-methods)
  - [Blog Methods](#blog-methods)
  - [Post Methods](#post-methods)
  - [Tagged Posts](#tagged-posts)
- [Examples](#examples)
  - [Reading Data](#reading-data)
  - [Creating Posts](#creating-posts)
  - [Queue Management](#queue-management)
- [Contributing](#contributing)
- [License](#license)

## AI Assistant Use Disclaimer

@pedroarnal has used Claude Code, an AI assistant by Anthropic, to support the codebase update to Ruby 3.4. The AI is
used as a development tool while maintaining human oversight of all changes.

## Requirements

* Ruby >= 3.4.0
* Faraday >= 2.0

## Installation

Install via RubyGems:

```bash
gem install tumblr_client
```

Or add to your Gemfile:

```ruby
gem 'tumblr_client'
```

## Usage

This gem provides a wrapper for the Tumblr v2 API. It does *not* handle the OAuth authentication flow automatically.
For full OAuth workflow implementation, use the [Ruby OAuth Gem](http://oauth.rubyforge.org/).

### Configuration

Configure the gem with your Tumblr API credentials:

```ruby
Tumblr.configure do |config|
  config.consumer_key = "your_consumer_key"
  config.consumer_secret = "your_consumer_secret"
  config.oauth_token = "your_oauth_token"
  config.oauth_token_secret = "your_oauth_token_secret"
end
```

Alternatively, create a `.tumblr` YAML file in your home directory:

```yaml
consumer_key: "your_consumer_key"
consumer_secret: "your_consumer_secret"
oauth_token: "your_oauth_token"
oauth_token_secret: "your_oauth_token_secret"
```

### The Console

Launch the interactive console to test API calls:

```bash
bin/tumblr
```

On first run without a `.tumblr` configuration file, the console will guide you through OAuth setup:

1. You'll be prompted for your `consumer_key` and `consumer_secret`
2. Visit the authorization URL displayed
3. After authorizing, copy the `oauth_verifier` from the redirect URL
4. Paste it back into the console

Your credentials will be saved to `~/.tumblr` for future use.

### Creating a Client

```ruby
# Create a client with default configuration
client = Tumblr::Client.new

# Or specify a custom Faraday adapter
client = Tumblr::Client.new(client: :httpclient)
```

## API Methods

### User Methods

```ruby
# Get user information
client.info

# Get user's dashboard
client.dashboard(limit: 20, offset: 0)

# Get user's likes
client.likes(limit: 20, before: 1234567890)

# Get blogs the user follows
client.following(limit: 20, offset: 0)

# Follow a blog
client.follow("example.tumblr.com")

# Unfollow a blog
client.unfollow("example.tumblr.com")

# Like a post
client.like(post_id, reblog_key)

# Unlike a post
client.unlike(post_id, reblog_key)

# Get filtered content
client.filtered_content

# Add filtered content
client.add_filtered_content(["spam", "unwanted"])

# Remove filtered content
client.delete_filtered_content(["spam"])
```

### Blog Methods

```ruby
# Get blog info
client.blog_info("example.tumblr.com")

# Get blog avatar URL
client.avatar("example.tumblr.com", 512)  # size: 16, 24, 30, 40, 48, 64, 96, 128, 512

# Get blog's posts
client.posts("example.tumblr.com", limit: 20, offset: 0)

# Get specific post type
client.posts("example.tumblr.com", type: "photo", limit: 10)

# Get a specific post
client.get_post("example.tumblr.com", post_id)

# Get post notes
client.notes("example.tumblr.com", post_id)

# Get blog's followers (requires authentication)
client.followers("yourblog.tumblr.com", limit: 20)

# Get blogs this blog follows (requires authentication)
client.blog_following("yourblog.tumblr.com", limit: 20)

# Check if a blog is followed by another
client.followed_by("yourblog.tumblr.com", "otherblog.tumblr.com")

# Get blog's likes
client.blog_likes("example.tumblr.com", limit: 20)

# Get queued posts (requires authentication)
client.queue("yourblog.tumblr.com")

# Get queue settings
client.queue_settings("yourblog.tumblr.com")

# Configure queue
client.configure_queue("yourblog.tumblr.com", post_frequency: 2, start_hour: 9, end_hour: 17)

# Pause queue
client.pause_queue("yourblog.tumblr.com")

# Resume queue
client.resume_queue("yourblog.tumblr.com")

# Reorder queue
client.reorder_queue("yourblog.tumblr.com", post_id: 123, insert_after: 456)

# Shuffle queue
client.shuffle_queue("yourblog.tumblr.com")

# Get draft posts (requires authentication)
client.drafts("yourblog.tumblr.com")

# Get submission posts (requires authentication)
client.submissions("yourblog.tumblr.com")

# Get notifications (requires authentication)
client.notifications("yourblog.tumblr.com")

# Get blocked blogs (requires authentication)
client.blocks("yourblog.tumblr.com")

# Block a blog (requires authentication)
client.block("yourblog.tumblr.com", "spammer.tumblr.com")

# Unblock a blog (requires authentication)
client.unblock("yourblog.tumblr.com", "notaspammer.tumblr.com")
```

### Post Methods

All post methods support these standard options: `:state`, `:tags`, `:tweet`, `:date`, `:markdown`, `:slug`, `:format`

```ruby
# Create a text post
client.text("yourblog.tumblr.com",
  title: "Hello World",
  body: "This is my first post!",
  tags: ["greeting", "first-post"]
)

# Create a photo post
client.photo("yourblog.tumblr.com",
  data: ['/path/to/photo.jpg'],
  caption: "Check out this photo!",
  tags: ["photography"]
)

# Create a photo post from URL
client.photo("yourblog.tumblr.com",
  source: "https://example.com/image.jpg",
  caption: "Photo from URL"
)

# Create a quote post
client.quote("yourblog.tumblr.com",
  quote: "The only way to do great work is to love what you do.",
  source: "Steve Jobs"
)

# Create a link post
client.link("yourblog.tumblr.com",
  url: "https://example.com",
  title: "Check this out",
  description: "An interesting link"
)

# Create a chat post
client.chat("yourblog.tumblr.com",
  title: "Conversation",
  conversation: "John: Hi!\nJane: Hello!"
)

# Create an audio post
client.audio("yourblog.tumblr.com",
  data: '/path/to/audio.mp3',
  caption: "Great song!"
)

# Create a video post
client.video("yourblog.tumblr.com",
  embed: '<iframe src="..."></iframe>',
  caption: "Cool video"
)

# Edit a post
client.edit("yourblog.tumblr.com",
  id: post_id,
  title: "Updated Title"
)

# Reblog a post
client.reblog("yourblog.tumblr.com",
  id: post_id,
  reblog_key: reblog_key,
  comment: "Great post!"
)

# Delete a post
client.delete("yourblog.tumblr.com", post_id)
```

### Tagged Posts

```ruby
# Get posts with a specific tag
client.tagged("ruby", limit: 20)
```

## Examples

### Reading Data

```ruby
# Get your user info
user_info = client.info
puts user_info["user"]["name"]

# Get the latest posts from a blog
posts = client.posts("staff.tumblr.com", limit: 5)
posts["posts"].each do |post|
  puts post["title"] || post["summary"]
end

# Get all photo posts from a blog
photos = client.posts("photography.tumblr.com", type: "photo", limit: 10)
```

### Creating Posts

```ruby
# Simple text post
client.text("myblog.tumblr.com",
  title: "Ruby is awesome!",
  body: "I'm posting this from the Tumblr Ruby gem.",
  tags: ["ruby", "programming"]
)

# Photo post with multiple images (photoset)
client.photo("myblog.tumblr.com",
  data: [
    '/path/to/photo1.jpg',
    '/path/to/photo2.jpg',
    '/path/to/photo3.jpg'
  ],
  caption: "My vacation photos",
  tags: ["travel", "photos"]
)

# Draft post (won't be published immediately)
client.text("myblog.tumblr.com",
  title: "Draft Post",
  body: "This is a draft",
  state: "draft"
)

# Scheduled post
client.text("myblog.tumblr.com",
  title: "Scheduled Post",
  body: "This will be published later",
  state: "queue"
)
```

### Queue Management

```ruby
# View your queue
queue = client.queue("myblog.tumblr.com")
puts "You have #{queue['posts'].length} posts in queue"

# Get current queue settings
settings = client.queue_settings("myblog.tumblr.com")
puts "Posts per day: #{settings['posts_per_day']}"

# Update queue to post twice daily between 9 AM and 5 PM
client.configure_queue("myblog.tumblr.com",
  post_frequency: 2,
  start_hour: 9,
  end_hour: 17
)

# Pause the queue
client.pause_queue("myblog.tumblr.com")

# Resume the queue
client.resume_queue("myblog.tumblr.com")

# Shuffle the queue order
client.shuffle_queue("myblog.tumblr.com")

# Reorder queue - move a post to appear after another post
client.reorder_queue("myblog.tumblr.com",
  post_id: 123456789,
  insert_after: 987654321
)
```

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details on:

- How to submit pull requests
- Code style guidelines
- Testing requirements
- The Contributor License Agreement (CLA)

Feel free to open an issue for bugs, feature requests, or questions.

---

Copyright 2013 Tumblr, Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not
use this work except in compliance with the License. You may obtain a copy of
the License in the LICENSE file, or at:

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
License for the specific language governing permissions and limitations.