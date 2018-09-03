From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH V2 2/6] x86/efi: Remove __init attribute from memory
 mapping functions
Date: Mon, 3 Sep 2018 09:12:07 +0200
Message-ID: <20180903071207.GA10249@zn.tnic>
References: <1535881594-25469-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1535881594-25469-3-git-send-email-sai.praneeth.prakhya@intel.com>
 <20180902105602.GA19431@zn.tnic>
 <FFF73D592F13FD46B8700F0A279B802F485B9142@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <FFF73D592F13FD46B8700F0A279B802F485B9142@ORSMSX114.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Neri, Ricardo" <ricardo.neri@intel.com>, "matt@codeblueprint.co.uk" <matt@codeblueprint.co.uk>, Lee Chun-Yi <jlee@suse.com>, Al Stone <astone@redhat.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Sep 03, 2018 at 05:03:56AM +0000, Prakhya, Sai Praneeth wrote:
> Hmm.. thought that __efi_init might be confusing with the normal __init attribute

How would that be confusing? It has "__efi" prepended?!

All I'm saying is, if you're going to define your own function
attributes, do them generic and short. "_fixup" is too specific IMO. It
also enlarges function definitions unnecessarily.

With "__efi_init" you already denote that it is a special attribute
which has relevance in the EFI code only. What you do about it - the
*fixup* - is the thing you do with the attribute. But you don't have to
have the "what you do" in the attribute name too.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
