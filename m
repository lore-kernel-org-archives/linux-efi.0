From: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Loading initrd above 4G causes freeze on boot
Date: Wed, 20 Aug 2014 22:05:08 +0300
Message-ID: <CAPWNY8V_gFutOcow5rBUSz2updGzf4hkQ98qBZ9WRGkb_sA2jA@mail.gmail.com>
References: <53E62EEF.9040801@gmail.com>
	<CAE9FiQVXkojPnTr4EQE7h2YhWqa5VBYRSCadB0B1qDL+eGY8jg@mail.gmail.com>
	<20140809192302.GJ15082@console-pimps.org>
	<CAPWNY8X+pRf4GuYAzKj-co0fkLMY0KNw+wB4KA8eaJ0QbE4MnA@mail.gmail.com>
	<CAE9FiQVDURMvgVd55-onMDejCZT+OZ2vrr92wx8FJMKRNSX_GA@mail.gmail.com>
	<CAPWNY8WvyAt5oT3cJ53A07tbfZctE9Y-m5f2Nucgc3hVvCgdjQ@mail.gmail.com>
	<20140813140219.GP15082@console-pimps.org>
	<CAPWNY8WdA+Q+WjXirGOsrYjMGp+69sCqYa8ST7_owQeVhQkT0w@mail.gmail.com>
	<20140813184449.GV15082@console-pimps.org>
	<20140820170520.GF29733@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140820170520.GF29733-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Aug 20, 2014 at 8:05 PM, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> =
wrote:
> On Wed, 13 Aug, at 07:44:49PM, Matt Fleming wrote:
>>
>> At this point, I think modifying the max address is the best way to
>> debug this further, and figure out what address causes the hang.
>
> Mantas, did you manage to get to the bottom of this issue?

I experimented with some things (like setting chunk size to a few kB
to see if it hangs earlier or only at the very end; etc.), and finally
found out that it stops freezing if I pad the initrd file to a
multiple of 512 bytes :/ That is, 5684268 bytes will freeze, 5684736
bytes will not.

=2E..In other words, seems like it cannot read chunks that aren't
multiples of 512 into a location above 4 GB. Or something like that...

--=20
Mantas Mikul=C4=97nas <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
