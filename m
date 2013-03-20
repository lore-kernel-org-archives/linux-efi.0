From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: efivarfs: Bad directory entry when variable has / in name
Date: Wed, 20 Mar 2013 08:41:17 +0000
Message-ID: <5149762D.6080907@console-pimps.org>
References: <4764b7f1f5e6d79938d476ea68b99199@shealevy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4764b7f1f5e6d79938d476ea68b99199-yfkUTty7RcRWk0Htik3J/w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shea-yfkUTty7RcRWk0Htik3J/w@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, "mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 03/19/2013 08:36 PM, shea-yfkUTty7RcRWk0Htik3J/w@public.gmane.org wrote:
> Hello,
> 
> When there is an EFI variable with a forward slash in its name, 
> /sys/firmware/efi/efivars contains a directory entry with a forward 
> slash, which of course causes all sorts of problems (e.g. EINVAL from 
> stat(2)). Off the top of my head, I can think of two ways to handle 
> this:
> 
> 1. Simply skip such variables when making the sysfs entries
> 2. Come up with an escaping scheme, e.g. "a single backslash is 
> actually a forward slash, two backslashes are actually a single 
> backslash" or some such.
> 
> Thoughts?

Right. Have you seen machines with such variable names in the wild?
There's nothing in the specification that prohibits the use of slashes
in variable names, so I'm not in favour of option 1 above and mangling
the variable name would likely cause too much confusion.

The best solution I can come up with is to create directories for any
variable names that contain "/" (which would also make it possible to
build filesystem hierarchies with EFI variables). The user could choose
to ignore the actual layout of the filesystem since opening the variable
"adirectory/file" with,

	open("adirectory/file-<guid>");

would work without it being necessary for the user to handle slashes in
variable names.

What do you think?

Presumably this is also an issue with the old EFI vars sysfs code?

-- 
Matt Fleming, Intel Open Source Technology Center
