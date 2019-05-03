From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/2 v2] efi: add a function to convert the status value to string
Date: Fri, 3 May 2019 08:16:42 +0200
Message-ID: <CAKv+Gu9KGE3dpkZ1J9B0_VX2AsiTnE3Zbs1kAcz-xeOcXfxYog@mail.gmail.com>
References: <20190502040441.30372-1-jlee@suse.com> <CAKv+Gu9mjtNEWN-w4ix7VJMZ_kk-Qf6FfYFRu2mCosaAjMA4Vg@mail.gmail.com>
 <20190503061518.GM11486@linux-l9pv.suse>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190503061518.GM11486@linux-l9pv.suse>
Sender: linux-kernel-owner@vger.kernel.org
To: joeyli <jlee@suse.com>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>, David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@fedoraproject.org>, Nayna Jain <nayna@linux.ibm.com>, Mimi Zohar <zohar@linux.ibm.com>, linux-efi <linux-efi@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
List-Id: linux-efi@vger.kernel.org

On Fri, 3 May 2019 at 08:15, joeyli <jlee@suse.com> wrote:
>
> On Thu, May 02, 2019 at 10:53:31AM +0200, Ard Biesheuvel wrote:
> > On Thu, 2 May 2019 at 06:04, Lee, Chun-Yi <joeyli.kernel@gmail.com> wrote:
> > >
> > > This function can be used to convert EFI status value to string
> > > for printing out debug message. Using this function can improve
> > > the readability of log.
> > >
> > > v2.
> >
> > Please move the changelog out of the commit log (move it below the ---
> > further down)
> >
>
> OK! I will moved the changelog out of the commit log.
>
> > > - Changed the wording in subject and description.
> > > - Moved the marco immediately after the status value definitions.
> > > - Turned into a proper function instead of inline.
> > >
> >
> > You missed my point here. A proper function means the function in a .c
> > file, and only the declaration in a .h file. This way, you are still
> > duplicating the literal strings into every object file that references
> > this function.
> >
>
> Sorry for I missunderstood. I will move the function to load_uefi.c.
>

No, please move it to a file that is shared between all EFI code.
