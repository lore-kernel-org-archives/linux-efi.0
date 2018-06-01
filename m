From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v3 2/5] efi: Add embedded peripheral firmware support
Date: Fri, 1 Jun 2018 21:23:46 +0200
Message-ID: <20180601192346.GQ4511@wotan.suse.de>
References: <20180408174014.21908-1-hdegoede@redhat.com>
 <20180408174014.21908-3-hdegoede@redhat.com>
 <20180423211143.GZ14440@wotan.suse.de>
 <71e6a45a-398d-b7a4-dab0-8b9936683226@redhat.com>
 <1524586021.3364.20.camel@linux.vnet.ibm.com>
 <20180424234219.GX14440@wotan.suse.de>
 <1524632409.3371.48.camel@linux.vnet.ibm.com>
 <20180425175557.GY14440@wotan.suse.de>
 <CAB0TPYGnCu+anWHBGvkaigxD--8uHQaQJ2c62kegJ7mTqvkmnA@mail.gmail.com>
 <20180508153805.GC27853@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180508153805.GC27853@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Martijn Coenen <maco@android.com>, Andy Gross <andy.gross@linaro.org>, David Brown <david.brown@linaro.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Stephen Boyd <sboyd@kernel.org>, Vikram Mulukutla <markivx@codeaurora.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>, Alan Cox <alan@linux.intel.com>, Kees Cook <keescook@chromium.org>, Hans de Goede <hdegoede@redhat.com>, Darren Hart <dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Greg
List-Id: linux-efi@vger.kernel.org

On Tue, May 08, 2018 at 03:38:05PM +0000, Luis R. Rodriguez wrote:
> On Fri, May 04, 2018 at 12:44:37PM -0700, Martijn Coenen wrote:
> > On Wed, Apr 25, 2018 at 10:55 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> > > Is ptr below
> > >
> > >         ret = request_firmware_into_buf(&seg_fw, fw_name, dev,
> > >                                         ptr, phdr->p_filesz);
> > >
> > > Also part of the DMA buffer allocated earlier via:
> > >
> > >         ret = qcom_scm_pas_init_image(pas_id, fw->data, fw->size);
> > >
> > > Android folks?
> > 
> > I think the Qualcomm folks owning this (Andy, David, Bjorn, already
> > cc'd here) are better suited to answer that question.
> 
> Andy, David, Bjorn?

Andy, David, Bjorn?

Note: as-is we have no option but to assume this is DMA memory for now.
We cannot keep IMA's guarantees with the current prealloc firmware API
buffer, so I've suggested:

a) The prealloc buffer API be expanded to enable the caller to descrbe it
b) Have the qcom driver say this is DMA
c) IMA would reject it to ensure it stays true to what it needs to gaurantee

d) Future platforms which want to use IMA but want to trust DMA buffers
   would need to devise a way to describe IMA can trust some of these
   calls.

I'll leave it up to you guys (Andy, David, Bjorn) to come up with the code for
d) once and if you guys want to use IMA later.  But since what is pressing here
is to stay to true to IMA, with a-c IMA would reject such calls for now.

  Luis
