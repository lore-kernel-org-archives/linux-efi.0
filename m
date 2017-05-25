From: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Subject: Re: [PATCH 3/5] Add the ability to lock down access to the running
 kernel image
Date: Thu, 25 May 2017 11:18:22 -0700
Message-ID: <fa6647c3-baff-d9e9-8ffe-89042b2a553d@schaufler-ca.com>
References: <80bdc6c9-004b-800f-ffd0-4b5ebf8cdeba@schaufler-ca.com>
 <149563711758.9419.11406612723056598045.stgit@warthog.procyon.org.uk>
 <149563714531.9419.16811189348445249219.stgit@warthog.procyon.org.uk>
 <19783.1495695202@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <19783.1495695202-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 5/24/2017 11:53 PM, David Howells wrote:
> Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org> wrote:
>
>>> +#ifdef CONFIG_LOCK_DOWN_KERNEL
>>> +extern bool kernel_is_locked_down(void);
>>> +#else
>>> +static inline bool kernel_is_locked_down(void)
>> Should this be a bool or an int? I can imagine that someone is going to want
>> various different degrees of lock down for kernels. As an int you could
>> return a bitmap indicating which features were locked. This would allow
>> additional things to be locked down without changing the interface.
> At the moment it makes no difference, since the return value is only ever
> passed directly to an if-statement.
>
> Also, do you have an idea as to how is should be divided up?

You called out five distinct features in 0/5, so how about
a bit for each of those?

Actually, I don't care which way you go. The current code works
for me. I am just concerned that the granularity fiends might come
around later.


>
> There aren't so many cases, at least not yet, that they can't be fixed up,
> perhaps with a coccinelle script.
>
> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
