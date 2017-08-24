From: "Jan Beulich" <JBeulich-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/2] EFI: move efi_mem_type() to common code
Date: Thu, 24 Aug 2017 04:34:41 -0600
Message-ID: <599EC7E1020000780017323F@prv-mh.provo.novell.com>
References: <599EB46E02000078001730B1@prv-mh.provo.novell.com>
 <CAKv+Gu9W12HqA+oK4p0COXpgSi=HWUg_xv5s=mO1YQf7oVtjMA@mail.gmail.com>
 <599EBCF102000078001730F3@prv-mh.provo.novell.com>
 <CAKv+Gu8WEO_T9bUiCz-QdBOj1pFw-tdit=ZW2kxpk124+_mMLw@mail.gmail.com>
 <599EC28602000078001731A1@prv-mh.provo.novell.com>
 <CAKv+Gu-A=Nt7pUm2fM5DXvgkLUwgto4--fTQ502SyiV4VNr-HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu-A=Nt7pUm2fM5DXvgkLUwgto4--fTQ502SyiV4VNr-HQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

>>> On 24.08.17 at 12:19, <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On 24 August 2017 at 11:11, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org> wrote:
>>>>> On 24.08.17 at 11:52, <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>>> If it already has its own version, I'd prefer we just add #ifndef
>>> CONFIG_IA64 around it instead.
>>
>> Which would then preclude other environments to override it.
> 
> ... which is what the comment says in the first place.
> 
>> I have such a case in an out-of-tree patch set (which is why
>> I've stumbled over this and the open-coding of it in the BGRT
>> code in the first place). Plus to me it seems preferable to have
>> both functions consistent (of course you could then as for
>> the __weak to be dropped from the other one).
>>
> 
> Making symbols __weak in mainline to accommodate unidentified
> out-of-tree users is something I'd prefer to avoid.

Would you then mind extending the #ifndef to the other function
as well, or would I need to make this a 3rd patch?

Jan
