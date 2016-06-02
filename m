From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v2 2/3] efi-pstore: implement efivars_pstore_exit()
Date: Thu, 2 Jun 2016 11:26:15 -0700
Message-ID: <CAGXu5jJgnPw7o_EbeyJhOgqCLxde-09tDoGiYHfiODOfZQ8b3A@mail.gmail.com>
References: <cover.1446869434.git.geliangtang@163.com> <337377a3fbcf855d6a5217e06fcd8c8a979f2853.1446869434.git.geliangtang@163.com>
 <c203e0cfee351d6f97c6a1a42c3e25b4be339f93.1446869434.git.geliangtang@163.com>
 <20151111165947.GD4889@codeblueprint.co.uk> <CAGXu5j+DADxC6LrHMSAnw5N2GRFbby6-iPTgkKC=BZotBqt-NQ@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F32B86A52@ORSMSX114.amr.corp.intel.com>
 <CAGXu5j+PZwpcRTNFpTYzw-Fs6OJLdvaNDGq=vsW7iEhWunc+8g@mail.gmail.com> <20160602072639.GA8456@OptiPlex>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160602072639.GA8456@OptiPlex>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 2, 2016 at 12:26 AM, Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org> wrote:
> On Wed, Nov 11, 2015 at 03:24:33PM -0800, Kees Cook wrote:
>> On Wed, Nov 11, 2015 at 3:23 PM, Luck, Tony <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> >>>>  module_init(efivars_pstore_init);
>> >>>
>> >>> Looks OK to me. Kees, are you picking this up?
>> >>
>> >> I can, though usually it goes through Tony.
>> >
>> > Can I count that as "Acked-by" from both of you?
>>
>> Yup, sorry. I thought I'd acked them already. :) My bad!
>>
>> Acked-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>>
>
> Hi Kees,
>
> Could you please apply these three pending patches for me?
> I think they are still valid. Thank you very much.

Yes, added to my for-next tree now. Thanks!

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
