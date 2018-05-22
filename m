From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH V3 2/3] efi: Introduce efi_queue_work() to queue any
 efi_runtime_service() on efi_rts_wq
Date: Tue, 22 May 2018 09:36:18 +0200
Message-ID: <20180522073618.GN12198@hirez.programming.kicks-ass.net>
References: <1526958784-14688-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1526958784-14688-3-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1526958784-14688-3-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>, Dave Hansen <dave.hansen@intel.com>, Mark Rutland <mark.rutland@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, Naresh Bhat <naresh.bhat@linaro.org>, Ricardo Neri <ricardo.neri@intel.com>, Ravi Shankar <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dan Williams <dan.j.williams@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
List-Id: linux-efi@vger.kernel.org

On Mon, May 21, 2018 at 08:13:03PM -0700, Sai Praneeth Prakhya wrote:
> +	/*								\
> +	 * queue_work() returns 0 if work was already on queue,         \
> +	 * _ideally_ this should never happen.                          \
> +	 */								\
> +	if (queue_work(efi_rts_wq, &efi_rts_work.work))			\
> +		flush_work(&efi_rts_work.work);				\

Since you're _always_ going to wait for it, it is _much_ cheaper to put
a completion in your actual work and wait for that.
