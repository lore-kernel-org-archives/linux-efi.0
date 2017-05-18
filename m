From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] efi-pstore: Fix read iter after pstore API refactor
Date: Thu, 18 May 2017 09:41:46 -0700
Message-ID: <CAGXu5jJ0aT7-qHexqyFvDhCSJWcxUVb3zZ=-mAT=x8UtHWOVcA@mail.gmail.com>
References: <20170512215854.GA85220@beast> <CAKv+Gu8H7aJd0jjdMav5V+PdfM3oyh=G3hGZPZtaiXcZ2PAtQg@mail.gmail.com>
 <CAGXu5j+-WJazbLOV2n3VS6SJc8fBUqgC+AzfEVYoxYWRto5=XQ@mail.gmail.com> <CAKv+Gu_Mxfgqww3T-xUmif-A=XaGbVai7nT+L1UvdO_ML3G2XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu_Mxfgqww3T-xUmif-A=XaGbVai7nT+L1UvdO_ML3G2XQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>, Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, May 18, 2017 at 9:18 AM, Ard Biesheuvel
<ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On 18 May 2017 at 14:01, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>> On Thu, May 18, 2017 at 3:35 AM, Ard Biesheuvel
>> <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>>> On 12 May 2017 at 22:58, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>>>> During the internal pstore API refactoring, the EFI vars read entry was
>>>> accidentally made to update a stack variable instead of the pstore
>>>> private data pointer. This corrects the problem (and removes the now
>>>> needless argument).
>>>>
>>>> Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>>>
>>> Does this need a cc stable?
>>
>> No, the refactor first appeared in 4.12-rc1.
>>
>
> OK. Applied.

Err, eek, no, it's already gone into Linus's tree.

-Kees

-- 
Kees Cook
Pixel Security
