From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [Xen-devel] [PATCH v5 2/3] x86: Remap GDT tables in the Fixmap section
Date: Mon, 13 Mar 2017 12:24:21 -0700
Message-ID: <CAJcbSZG75_cHxWp2eJ+XPiKZMbf2NNGwoS+8qkmXQ=rH2FURCQ@mail.gmail.com>
References: <20170306220348.79702-1-thgarnie@google.com> <20170306220348.79702-2-thgarnie@google.com>
 <CALCETrVXHc-EAhBtdhL9FXSW1G2VbohRY4UJuOtpRG1K0Q-Ogg@mail.gmail.com>
 <17ffcc5b-1c9a-51b6-272a-5eaecf1bc0c4@citrix.com> <CALCETrWv-u7OdjWDY+5eF7p-ngPun-yYf0QegMzYc6MGVQd-4w@mail.gmail.com>
 <CAJcbSZExVWA0jvAoxLLc+58Ag9cHchifrHP=fFfzU_onHo2PyA@mail.gmail.com>
 <5cf31779-45c5-d37f-86bc-d5afb3fb7ab6@oracle.com> <51c23e92-d1f0-427f-e069-c92fc4ed6226@oracle.com>
 <CAJcbSZEnUBfLHjf+bHqY0JQhQXD9urX45BXrQjx=1=A5gPpp_w@mail.gmail.com>
 <36579cc4-05e7-a448-767c-b9ad940362fc@oracle.com> <f2230734-a13f-6c0d-8a01-15fd4408e799@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <f2230734-a13f-6c0d-8a01-15fd4408e799@oracle.com>
Sender: owner-linux-mm@kvack.org
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>, Stanislaw Gruszka <sgruszka@redhat.com>, kvm list <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Frederic Weisbecker <fweisbec@gmail.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Chris Wilson <chris@chris-wilson.co.uk>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Dave Hansen <dave.hansen@intel.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Alexander Potapenko <glider@google.com>, Pavel Machek <pavel@ucw.cz>, "H . Peter Anvin" <hpa@zytor.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jiri Olsa <jolsa@redhat.com>, zijun_hu <zijun_hu@htc.com>, Prarit Bhargava <prarit@redhat.com>, Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>Jonathan Corbet <c>
List-Id: linux-efi@vger.kernel.org

On Mon, Mar 13, 2017 at 11:32 AM, Boris Ostrovsky
<boris.ostrovsky@oracle.com> wrote:
> There are a couple of problems for Xen PV guests that need to be addressed:
> 1. Xen's set_fixmap op needs non-default handling for
> FIX_GDT_REMAP_BEGIN range
> 2. GDT remapping for PV guests needs to be RO for both 64 and 32-bit guests.
>
> I don't know how you prefer to deal with (2), patch below is one
> suggestion. With it all my boot tests (Xen and bare-metal) passed.
>

Good suggestion, I think I will use most of it. Thanks!

> One problem with applying it directly is that kernel becomes
> not-bisectable (Xen-wise) between patches 2 and 3 so perhaps you might
> pull some of the changes from patch 3 to patch 2.
>

Yes that make sense, I will have to add the global variable on patch 2
and rebase 3 correctly.

-- 
Thomas

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
