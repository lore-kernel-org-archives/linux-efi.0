From: Kees Cook <keescook@chromium.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Date: Fri, 14 Mar 2014 08:54:23 -0700
Message-ID: <CAGXu5j+3vVKhFPOsArYddA+QqhvVUunj8eYOF799rDv=3MGtyg@mail.gmail.com>
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
	<CAGXu5jLZcWh5WD0L8s3Q-GXdXCMnA57qtjfdFfQbv0fxYcuCTQ@mail.gmail.com>
	<1394811997.26846.2.camel@x230.mview.int.nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1394811997.26846.2.camel@x230.mview.int.nebula.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jmorris@namei.org" <jmorris@namei.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hpa@zytor.com" <hpa@zytor.com>, "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>, "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Mar 14, 2014 at 8:46 AM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> On Fri, 2014-03-14 at 08:23 -0700, Kees Cook wrote:
>
>> The command line problem here is a total red herring. If you've got a
>> measured kernel, you have a measured command line. (If not, you don't
>> have a measured kernel.) Dealing with the command line has nothing to
>> do with enforcing the ring0/uid0 boundary which is what this patch
>> series does.
>
> That's why I used trusted rather than measured. The Secure Boot trust
> model assumes that the user is able to modify the command line (it's
> basically impossible to deploy generically otherwise), so we need to
> filter out command line options that allow a user to elevate themselves
> into the kernel at boot time.

All the more reason to ignore command line at this point. For Chrome
OS, it's part of our boot state, so we don't care about it. For
generic Secure Boot, we can add checks for dangerous stuff as we go
forward. That's why I like this interface -- we can add to it as we
identify bad stuff, and it stay separate from other semantics.

-Kees

-- 
Kees Cook
Chrome OS Security
