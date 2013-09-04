From: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH V2 10/10] Add option to automatically enforce module
 signatures when in Secure Boot mode
Date: Wed, 4 Sep 2013 08:01:52 -0400
Message-ID: <CA+5PVA4J1mL0o=MHM-D81rcViR+E3JUyGChvHe8P+3+yt3v_qA@mail.gmail.com>
References: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
	<1376933171-9854-11-git-send-email-matthew.garrett@nebula.com>
	<20130829183713.GT20828@hansolo.jdub.homelinux.org>
	<522104A6.5000700@zytor.com>
	<20130830234133.GR20828@hansolo.jdub.homelinux.org>
	<1378291877.6380.74.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378291877.6380.74.camel-ONCj+Eqt86TasUa73XJKwA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Sep 4, 2013 at 6:51 AM, joeyli <jlee-IBi9RG/b67k@public.gmane.org> wrote:
> =A9=F3 =A4=AD=A1A2013-08-30 =A9=F3 19:41 -0400=A1AJosh Boyer =B4=A3=A8=
=EC=A1G
>> On Fri, Aug 30, 2013 at 01:46:30PM -0700, H. Peter Anvin wrote:
>> > On 08/29/2013 11:37 AM, Josh Boyer wrote:
>> > >>          setup_efi_pci(boot_params);
>> > >> diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/i=
nclude/uapi/asm/bootparam.h
>> > >> index c15ddaf..d35da96 100644
>> > >> --- a/arch/x86/include/uapi/asm/bootparam.h
>> > >> +++ b/arch/x86/include/uapi/asm/bootparam.h
>> > >> @@ -131,7 +131,8 @@ struct boot_params {
>> > >>          __u8  eddbuf_entries;                           /* 0x1=
e9 */
>> > >>          __u8  edd_mbr_sig_buf_entries;                  /* 0x1=
ea */
>> > >>          __u8  kbd_status;                               /* 0x1=
eb */
>> > >> -        __u8  _pad5[3];                                 /* 0x1=
ec */
>> > >> +        __u8  secure_boot;                              /* 0x1=
ec */
>> > >> +        __u8  _pad5[2];                                 /* 0x1=
ec */
>> > >>          /*
>> > >>           * The sentinel is set to a nonzero value (0xff) in he=
ader.S.
>> > >>           *
>> > >
>> > > You need to include the following chunk of code with this, other=
wise the
>> > > secure_boot variable gets cleared.
>> > >
>> >
>> > Not really.
>> >
>> > There are three cases:
>> >
>> > 1. Boot stub only.  Here we do the right thing with the bootparams=
=2E
>> > 2. Boot loader bypasses the boot stub completely.  Here we MUST NO=
T do
>> >    what you suggest above.
>> > 3. Boot stub with a boot_params structure passed in.  Here we shou=
ld
>> >    run sanitize_boot_params() (an inline for a reason) in the boot
>> >    stub, before we set the secure_boot field.  Once that is done, =
we
>> >    again don't need that modification.
>>
>> OK.  If 3 works, then great.  All I know is that Fedora has been
>> carrying the above hunk for months and it was missing in this patch =
set.
>> So when I went to test it, the patches didn't do anything because th=
e
>> secure_boot field was getting cleared.
>>
>> I'm more than happy to try option 3, and I'll poke at it next week
>> unless someone beats me to it.
>>
>> josh
>
> The secure_boot field cleaned by sanitize_boot_params() when using gr=
ub2
> linuxefi to load efi stub kernel.
> I printed the boot_params->sentinel value, confirm this value is NOT =
0
> when running grub2 linuxefi path, the entry point is efi_stub_entry.
>
> On the other hand,
> the sentinel value is 0 when direct run efi stub kernel in UEFI shell=
,
> the secure_boot field can keep.
>
> Does that mean grub2 should clean the sentinel value? or we move the =
get
> secure_boot value to efi_init()?

See V3 of this patch that Matthew sent yesterday.  It calls
sanitize_boot_params in efi_main before calling get_secure_boot.  I
tested that yesterday and it worked fine.

josh
