From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Date: Sat, 15 Mar 2014 00:15:42 +0000
Message-ID: <20140315001542.769cff6c@alan.etchedpixels.co.uk>
References: <1394746248.27846.3.camel@x230>
	<20140313232140.03bdaac3@alan.etchedpixels.co.uk>
	<1394762250.6416.24.camel@x230.lan>
	<20140314122231.17b9ca8a@alan.etchedpixels.co.uk>
	<1394801518.6416.38.camel@x230.lan>
	<20140314170655.0ce398a3@alan.etchedpixels.co.uk>
	<1394820664.26846.18.camel@x230.mview.int.nebula.com>
	<20140314214806.54a3d031@alan.etchedpixels.co.uk>
	<1394834193.1286.11.camel@x230>
	<20140314220840.29a12171@alan.etchedpixels.co.uk>
	<20140314231832.GA653@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20140314231832.GA653@thunk.org>
Sender: linux-security-module-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jmorris@namei.org" <jmorris@namei.org>, "keescook@chromium.org" <keescook@chromium.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hpa@zytor.com" <hpa@zytor.com>, "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
List-Id: linux-efi@vger.kernel.org

> So as far as the narrow question of whether we should accept these
> patches, I think it's a good thing.  Personally, I'm always going to
> be disabling UEFI secure boot (even if it doesn't brick my laptop),
> because for me, the security guarantees it provides isn't worth it.
> But there will be people who want to be able to install Linux on
> Windows 8 certified PC's without tweaking BIOS settings, so merging
> the UEFI secure boot is a good thing, so long as those of use who
> don't want to have anything to do with UEFI secure boot can disable
> it.

I definitely think we want the feature and there are a lot of non UEFI
reasons for this (eg running trusted_kernel() virtual namespaces). I have
three specific issues

1. The implementation is a mess in part because it propogates more policy
all over the place that should be separated. Root cause capable() mixes
policy and activity. Fix suggested in my previous emails (and offer to do
the work)

2. It's likely to lead to more bugs and errors because of the way it has
been done and it doesn't break old code that gets added without
considering the issue. It fails insecure which is bad. Fixed by doing
what I suggested (and offered to do)

3. For things like module options we should be white not blacklisting
'bad' ones.

I've offered to go and fix up the capability stuff - I'm just waiting for
Matthew to actually confirm the question I specifically asked him - does
this solve that bit of his problem. If it does great, I'll go and sort
the capability bits out so we can keep the policy in the right place and
we don't have the kernel festooned with && !trusted_kernel() everywhere.

There is a question of completeness but its very clear we get there with
a combination of two things - whitelisting so we catch stuff we missed
rather than leave holes, and just accepting the reality that it'll take a
few kernels once its upstream until we get them all.

I care about security, we should do the job properly. We have a
further magnitude shift in security needs coming that's going to be at
least equivalent to the scale of shift between the old 'university,
everyone is nice' internet and today.

Alan
