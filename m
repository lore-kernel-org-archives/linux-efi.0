From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Date: Wed, 19 Mar 2014 12:50:41 -0700
Message-ID: <CAGXu5jKBtVhg6tYYDyQHcmrmOa1JduGkp6YgXvQeqm3CMEnc1w@mail.gmail.com>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	<CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>
	<alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>
	<1394686919.25122.2.camel@x230>
	<CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>
	<alpine.LRH.2.02.1403132031460.11638@tundra.namei.org>
	<1394726363.25122.16.camel@x230>
	<20140313212450.67f1de8e@alan.etchedpixels.co.uk>
	<1394746248.27846.3.camel@x230>
	<20140313232140.03bdaac3@alan.etchedpixels.co.uk>
	<1394762250.6416.24.camel@x230.lan>
	<20140314122231.17b9ca8a@alan.etchedpixels.co.uk>
	<1394801518.6416.38.camel@x230.lan>
	<20140314170655.0ce398a3@alan.etchedpixels.co.uk>
	<1394820664.26846.18.camel@x230.mview.int.nebula.com>
	<20140314214806.54a3d031@alan.etchedpixels.co.uk>
	<1394834193.1286.11.camel@x230>
	<20140314220840.29a12171@alan.etchedpixels.co.uk>
	<1394835345.1286.22.camel@x230>
	<20140314223150.0b49723e@alan.etchedpixels.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140314223150.0b49723e-mUKnrFFms3BCCTY1wZZT65JpZx93mCW/@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org" <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org" <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Mar 14, 2014 at 3:31 PM, One Thousand Gnomes
<gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org> wrote:
> On Fri, 14 Mar 2014 22:15:45 +0000
> Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org> wrote:
>
>> On Fri, 2014-03-14 at 22:08 +0000, One Thousand Gnomes wrote:
>> > On Fri, 14 Mar 2014 21:56:33 +0000
>> > Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org> wrote:
>> > > Signed userspace is not a requirement, and therefore any solution that
>> > > relies on a signed initrd is inadequate. There are use cases that
>> > > require verification of the initrd and other levels. This isn't one of
>> > > them.
>> >
>> > The job of the kernel is to solve the general problem. There are lots of
>> > people who happen to care about verification beyond the kernel so it
>> > shouldn't be ignored. And they can do do things like load trusted SELinux
>> > rulesets even if you can't support it in your environment.
>>
>> The general problem includes having to support this even without an
>> selinux policy.
>
> Yes. No dispute about that. But equally the general solution should allow
> for it.
>
>> And one that's not going to change, so the general problem includes not
>> relying on a signed initramfs.
>
> Likewise
>
>> some other way. ChromeOS will load unmeasured kernel modules provided it
>> can attest to the trustworthyness of the filesystem containing them.
>
> See "How to Bypass Verified Boot Security in Chromium OS" 8)

That method a) is intentionally available (system owner can disable
firmware RO and install their own keys), and b) requires physical
presence.

> So ChromeOS loads *measured* kernel modules. It just did the measuring
> differently to the signed module code.

Right, using dm-verity. However, the read-only media case is still
valid (and is why I am still trying to get the module restrictions LSM
accepted, and why I'm modelling my firmware restrictions on the same
principle).

-Kees

-- 
Kees Cook
Chrome OS Security
