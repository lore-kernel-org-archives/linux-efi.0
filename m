From: David Lang <david-gFPdbfVZQbY@public.gmane.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Date: Fri, 14 Mar 2014 13:37:30 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1403141335590.12964@nftneq.ynat.uz>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>  <CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>  <alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>  <1394686919.25122.2.camel@x230>
 <CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>  <alpine.LRH.2.02.1403132031460.11638@tundra.namei.org>  <1394726363.25122.16.camel@x230>  <20140313212450.67f1de8e@alan.etchedpixels.co.uk>  <1394746248.27846.3.camel@x230>
 <20140313232140.03bdaac3@alan.etchedpixels.co.uk>  <1394762250.6416.24.camel@x230.lan>  <20140314122231.17b9ca8a@alan.etchedpixels.co.uk>  <1394801518.6416.38.camel@x230.lan>  <20140314170655.0ce398a3@alan.etchedpixels.co.uk>  <1394820664.26846.18.camel@x230.mview.int.nebula.com>
 <1394825094.1286.1.camel@x230>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1394825094.1286.1.camel@x230>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: "gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org" <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org" <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org" <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 14 Mar 2014, Matthew Garrett wrote:

> On Fri, 2014-03-14 at 14:11 -0400, Matthew Garrett wrote:
>
>> The fact that you keep saying measured really does make me suspect that
>> you misunderstand the problem. There's no measurement involved, there's
>> simply an assertion that the firmware (which you're forced to trust)
>> chose, via some policy you may be unaware of, to trust the booted
>> kernel.
>
> As an example, imagine a platform with the bootloader and kernel on
> read-only media. The platform can assert that the kernel is trusted even
> if there's no measurement of the kernel.

Trusted by who?

Alan is saying measured because then if it matches what the owner of that device 
intends it's trusted, but just because you trust it doesn't mean that I trust 
it, and it doesn't mean that the russian government should trust it, etc.

There just isn't one value of trust.

David Lang
