From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: Problem with new X.509 is_hash_blacklisted() interface
Date: Wed, 21 Jun 2017 15:07:31 +0200
Message-ID: <CAKv+Gu9KuogQkfgqKYJt40oW2tvuuVi+w29tp_2KLUqcWvM83A@mail.gmail.com>
References: <1495897525.3458.7.camel@HansenPartnership.com>
 <26151.1497974983@warthog.procyon.org.uk> <CAKv+Gu-Lwrd_=g6QNFxk5nKeh=wovstbEoc86M+0QUnwvU6ukA@mail.gmail.com>
 <8099.1498049349@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8099.1498049349-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 21 June 2017 at 14:49, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>
>> >      This can be told to skip a particular algorithm for when the caller
>> >      has one precalculated.  The precalculated hash can be passed to
>> >      is_hash_blacklisted().  This would typically be the case for a signed
>> >      X.509 message.
>>
>> This last part seems a premature optimization to me. Is there a
>> performance concern preventing us from using (4) only?
>
> Crypto stuff is relatively slow - and in the case of X.509 and PKCS#7 the
> caller will already have calculated a hash.  The most likely situation
> currently, I think, is that we will only have sha256 hashes in the blacklist,
> and whatever we're checking will have a sha256 hash also.
>
> Possibly, I could just pass the precalculated hash into is_data_blacklisted()
> and so avoid having to call is_hash_blacklisted() from outside.
>

That would be cleaner, yes. As I said, it looks correct to me, but I
would simply prefer to keep the code as simple as possible. If there
is a good reason for the additional fast path, then I have no
objections at all.

>> In any case, the approach and the code look sound to me, although I
>> think adding a hash of a type that we don't know how to calculate
>> deserves a warning at least.
>
> There are two issues with that:
>
>  (1) We don't know what hashes are available without checking to see what
>      modules are available.  However, to do this would involve loading the
>      hash algorithm module - but we might not be in a position to do this yet
>      (the blacklist is loaded before we start userspace).
>

Ah ok. That does complicate matters, indeed.

>  (2) A module implementing a hash algorithm might be blacklisted by the hash
>      that we've been given to add to the blacklist.  I think this is a more
>      general problem - and might require us to restrict blacklisting to hash
>      algorithms that are built in.
>

That makes sense, but deserves another big fat warning when it turns
out that the blacklist contains an entry we cannot verify against.
