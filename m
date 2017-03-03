From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 0/2] capsule pstore backend
Date: Fri, 3 Mar 2017 17:28:08 +0000
Message-ID: <CAKv+Gu8m+w=v+Mq21=vhnd9MM3n4qxvZECuMk9haoz7dpY0kVQ@mail.gmail.com>
References: <20170301175943.87444-1-qiuxu.zhuo@intel.com> <CAKv+Gu-PjFD8eAAOau6wPXH+pQ8JfKh-huFqiB+Go+5YTth3tQ@mail.gmail.com>
 <20170303172319.GA27957@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170303172319.GA27957-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 3 March 2017 at 17:23, Luck, Tony <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Fri, Mar 03, 2017 at 03:19:51PM +0000, Ard Biesheuvel wrote:
>> On 1 March 2017 at 17:59, Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> > *** BLURB HERE ***
>> >
>>
>> FYI the UEFI spec is vague about the exact format of the per-GUID
>> capsule configuration table entries, and so we have asked the USWG for
>> clarification. In the mean time, I'd like to refrain from merging
>> anything based on it, so unfortunately, we are going to have to park
>> this for now.
>
> Ard,
>
> Any estimates on how long that process takes? How often does the USWG
> meet? How would clarification be communicated (would we have to wait
> for the next version of the UEFI spec!?)
>

The USWG meets weekly, and it doesn't necessarily takes lots of time
to clarify something that is already in the spec, i.e., we wouldn't
have to wait for the errata to be released to actually share the
clarified information.

I'd say order weeks

Regards,
Ard.
