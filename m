From: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Subject: Re: Loading initrd above 4G causes freeze on boot
Date: Wed, 20 Aug 2014 20:53:45 +0100
Message-ID: <53F4FCC9.1030405@fensystems.co.uk>
References: <53E62EEF.9040801@gmail.com>	<CAE9FiQVXkojPnTr4EQE7h2YhWqa5VBYRSCadB0B1qDL+eGY8jg@mail.gmail.com>	<20140809192302.GJ15082@console-pimps.org>	<CAPWNY8X+pRf4GuYAzKj-co0fkLMY0KNw+wB4KA8eaJ0QbE4MnA@mail.gmail.com>	<CAE9FiQVDURMvgVd55-onMDejCZT+OZ2vrr92wx8FJMKRNSX_GA@mail.gmail.com>	<CAPWNY8WvyAt5oT3cJ53A07tbfZctE9Y-m5f2Nucgc3hVvCgdjQ@mail.gmail.com>	<20140813140219.GP15082@console-pimps.org>	<CAPWNY8WdA+Q+WjXirGOsrYjMGp+69sCqYa8ST7_owQeVhQkT0w@mail.gmail.com>	<20140813184449.GV15082@console-pimps.org>	<20140820170520.GF29733@console-pimps.org> <CAPWNY8V_gFutOcow5rBUSz2updGzf4hkQ98qBZ9WRGkb_sA2jA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPWNY8V_gFutOcow5rBUSz2updGzf4hkQ98qBZ9WRGkb_sA2jA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?B?TWFudGFzIE1pa3VsxJduYXM=?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 20/08/14 20:05, Mantas Mikul=C4=97nas wrote:
> On Wed, Aug 20, 2014 at 8:05 PM, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org=
> wrote:
>> On Wed, 13 Aug, at 07:44:49PM, Matt Fleming wrote:
>>>
>>> At this point, I think modifying the max address is the best way to
>>> debug this further, and figure out what address causes the hang.
>>
>> Mantas, did you manage to get to the bottom of this issue?
>
> I experimented with some things (like setting chunk size to a few kB
> to see if it hangs earlier or only at the very end; etc.), and finall=
y
> found out that it stops freezing if I pad the initrd file to a
> multiple of 512 bytes :/ That is, 5684268 bytes will freeze, 5684736
> bytes will not.
>
> ...In other words, seems like it cannot read chunks that aren't
> multiples of 512 into a location above 4 GB. Or something like that..=
=2E

I haven't been following this thread closely, but that immediately=20
sounds like a problem within the EFI_DISK_IO_PROTOCOL implementation=20
(which is responsible for handling smaller-than-block-sized reads).=20
Looking at the EDK2 implementation in=20
MdeModulePkg/Universal/Disk/DiskIoDxe/DiskIo.c, the memory management=20
does appear to be somewhat inventive.  In particular, there's a frequen=
t=20
pattern in DiskIoCreateSubtaskList() equivalent to:

   if ( blocking_io ) {
      buffer =3D some_static_buffer;
   } else {
      buffer =3D malloc ( len );
      if ( ! buffer )
         goto single_shared_error_label;
   }
   ... do not record whether or not buffer was dynamically allocated ..=
=2E
   ... use buffer as part of an asynchronous I/O operation ...
   ... eventually choose whether or not to free buffer, and hope the=20
choice is correct ...

It's not at all obvious that memory is freed correctly, especially unde=
r=20
some of the error paths within that code.

I can't immediately see anything that should fail with a pointer above=20
4G, but I wouldn't be surprised to find a path that causes a double fre=
e=20
or similar error.

Apologies if I've missed something critical earlier in the thread,=20
making my ramblings are totally irrelevant.

Michael
