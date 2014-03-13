From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Date: Thu, 13 Mar 2014 14:28:01 -0700
Message-ID: <532222E1.2020405@zytor.com>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>	<CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>	<alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>	<1394686919.25122.2.camel@x230>	<CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>	<alpine.LRH.2.02.1403132031460.11638@tundra.namei.org>	<1394726363.25122.16.camel@x230> <20140313212450.67f1de8e@alan.etchedpixels.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20140313212450.67f1de8e@alan.etchedpixels.co.uk>
Sender: linux-security-module-owner@vger.kernel.org
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Matthew Garrett <matthew.garrett@nebula.com>
Cc: "jmorris@namei.org" <jmorris@namei.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "keescook@chromium.org" <keescook@chromium.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
List-Id: linux-efi@vger.kernel.org

On 03/13/2014 02:24 PM, One Thousand Gnomes wrote:
> 
> If I have CAP_SYS_RAWIO I can make arbitary ring 0 calls from userspace,
> trivially and in a fashion well known and documented.
> 

... and once we eliminate CAP_SYS_RAWIO a bunch of the patches become
redundant.

	-hpa

