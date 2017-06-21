From: David Howells <dhowells@redhat.com>
Subject: Re: Problem with new X.509 is_hash_blacklisted() interface
Date: Wed, 21 Jun 2017 13:49:09 +0100
Message-ID: <8099.1498049349@warthog.procyon.org.uk>
References: <CAKv+Gu-Lwrd_=g6QNFxk5nKeh=wovstbEoc86M+0QUnwvU6ukA@mail.gmail.com> <1495897525.3458.7.camel@HansenPartnership.com> <26151.1497974983@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-Lwrd_=g6QNFxk5nKeh=wovstbEoc86M+0QUnwvU6ukA@mail.gmail.com>
Content-ID: <8098.1498049349.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: dhowells@redhat.com, James Bottomley <James.Bottomley@hansenpartnership.com>, keyrings@vger.kernel.org, linux-security-module <linux-security-module@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> >      This can be told to skip a particular algorithm for when the caller
> >      has one precalculated.  The precalculated hash can be passed to
> >      is_hash_blacklisted().  This would typically be the case for a signed
> >      X.509 message.
> 
> This last part seems a premature optimization to me. Is there a
> performance concern preventing us from using (4) only?

Crypto stuff is relatively slow - and in the case of X.509 and PKCS#7 the
caller will already have calculated a hash.  The most likely situation
currently, I think, is that we will only have sha256 hashes in the blacklist,
and whatever we're checking will have a sha256 hash also.

Possibly, I could just pass the precalculated hash into is_data_blacklisted()
and so avoid having to call is_hash_blacklisted() from outside.

> In any case, the approach and the code look sound to me, although I
> think adding a hash of a type that we don't know how to calculate
> deserves a warning at least.

There are two issues with that:

 (1) We don't know what hashes are available without checking to see what
     modules are available.  However, to do this would involve loading the
     hash algorithm module - but we might not be in a position to do this yet
     (the blacklist is loaded before we start userspace).

 (2) A module implementing a hash algorithm might be blacklisted by the hash
     that we've been given to add to the blacklist.  I think this is a more
     general problem - and might require us to restrict blacklisting to hash
     algorithms that are built in.

David
