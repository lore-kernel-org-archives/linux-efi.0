From: "Song, Ge" <ge.song-PT9Dzx9SjPiXmMXjJBpWqg@public.gmane.org>
Subject: RE: [RFT PATCH] efi: capsule-loader: reinstate virtual capsule
 mapping
Date: Tue, 2 Jan 2018 06:15:13 +0000
Message-ID: <b76bd828334240c280343c9117517dcc@HXTBJIDCEMVIW02.hxtcorp.net>
References: <20171226132142.3254-1-ard.biesheuvel@linaro.org>
 <35d1f2df-88e1-cb43-9488-e3cad896869a@nexus-software.ie>,<CAKv+Gu9o445bLK9crJX3ZomWLG+oOFDrp48EKvvp6OQwh=FMgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu9o445bLK9crJX3ZomWLG+oOFDrp48EKvvp6OQwh=FMgw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Richard Ruigrok <rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "Li, Jingyu" <jingyu.li-PT9Dzx9SjPiXmMXjJBpWqg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Ard, sorry for the delayed response. Working on HXT ARM Server Reference
Evaluation Platform based on 4.15.0-rc5

Tested-by: Ge Song <ge.song-PT9Dzx9SjPiXmMXjJBpWqg@public.gmane.org>    
________________________________________
From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sent: Saturday, December 30, 2017 12:35 AM
To: Bryan O'Donoghue
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Matt Fleming; Jan Kiszka; Richard Ruigrok; Song, Ge
Subject: Re: [RFT PATCH] efi: capsule-loader: reinstate virtual capsule mapping

On 29 December 2017 at 03:09, Bryan O'Donoghue
<pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org> wrote:
>
>> So we need to fix this without breaking Quark. Fortunately, Quark does
>> not appear to care about the virtual mapping, and so we can simply
>> do a partial revert of commit 2a457fb31df6 ("efi/capsule-loader: Use
>> page addresses rather than struct page pointers"), and create a vmap()
>> mapping of the entire capsule (including header) based on the reinstated
>> struct page array, unless running on Quark, in which case we pass the
>> capsule header copy as before.
>
>
>
> Working on the Galileo (Quark x1000 non-secure) Ard. I've tested a capsule
> with and without the quirk header so it should work on the secure part too.
>
> Tested-by: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
>

Thanks Bryan

Ge, Richard, any feedback? Thanks.
