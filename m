From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: Loading initrd above 4G causes freeze on boot
Date: Wed, 20 Aug 2014 18:05:20 +0100
Message-ID: <20140820170520.GF29733@console-pimps.org>
References: <53E62EEF.9040801@gmail.com>
 <CAE9FiQVXkojPnTr4EQE7h2YhWqa5VBYRSCadB0B1qDL+eGY8jg@mail.gmail.com>
 <20140809192302.GJ15082@console-pimps.org>
 <CAPWNY8X+pRf4GuYAzKj-co0fkLMY0KNw+wB4KA8eaJ0QbE4MnA@mail.gmail.com>
 <CAE9FiQVDURMvgVd55-onMDejCZT+OZ2vrr92wx8FJMKRNSX_GA@mail.gmail.com>
 <CAPWNY8WvyAt5oT3cJ53A07tbfZctE9Y-m5f2Nucgc3hVvCgdjQ@mail.gmail.com>
 <20140813140219.GP15082@console-pimps.org>
 <CAPWNY8WdA+Q+WjXirGOsrYjMGp+69sCqYa8ST7_owQeVhQkT0w@mail.gmail.com>
 <20140813184449.GV15082@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140813184449.GV15082-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 13 Aug, at 07:44:49PM, Matt Fleming wrote:
> 
> At this point, I think modifying the max address is the best way to
> debug this further, and figure out what address causes the hang.

Mantas, did you manage to get to the bottom of this issue?

-- 
Matt Fleming, Intel Open Source Technology Center
