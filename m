From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] x86, efi: retry ExitBootServices() on failure
Date: Mon, 17 Jun 2013 18:41:30 +0800
Message-ID: <1371465690.6523.331.camel@linux-s257.site>
References: <1370933558-10128-1-git-send-email-matt@console-pimps.org>
	 <1371139233.6523.272.camel@linux-s257.site>
	 <20130617092107.GA5440@console-pimps.org>
	 <51BEF71402000078000DEC12@nat28.tlf.novell.com>
	 <20130617101745.GB8569@console-pimps.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-qKDLrrS1szolY5Edu2H+"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130617101745.GB8569-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Zach Bobroff <zacharyb-gH/BEeFdNRQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


--=-qKDLrrS1szolY5Edu2H+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

於 一，2013-06-17 於 11:17 +0100，Matt Fleming 提到：
> On Mon, 17 Jun, at 10:46:28AM, Jan Beulich wrote:
> > To me, all this looks like it is being done on phenomenological basis,
> > taking a particular build of a particular firmware implementation as
> > the reference. Imo we shouldn't change the code in this way. This
> > also applies to the fact that the step is being doubled rather than
> > e.g. tripled: With it ending up a "again" anyway (see below), what's
> > the point of avoiding one more of the iterations?
> > 
> > Generic considerations would result in the increment being at least
> > 3 * element size; twice the element size assumes that the allocator
> > would behave in certain ways (like returning the head or tail part of
> > a larger piece of memory).
>  
> I have no issue with changing the multiplier. But let's get
> clarification from Zach as to what exactly is going on here.
> 
> > I agree that there ought to be an upper limit. But a single retry here
> > again looks like a tailored solution to a particular observed (mis-)
> > behavior, rather than something resulting from general considerations.
> 
> What value would you suggest for the retry?
> 

Currently grub2 retry unlimited times like attached patch.

But, I also agree need have a upper limit.


Thanks a lot!
Joey Lee


--=-qKDLrrS1szolY5Edu2H+
Content-Disposition: attachment; filename="bug-823386_grub-r4778.diff"
Content-Type: text/x-patch; name="bug-823386_grub-r4778.diff"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

------------------------------------------------------------
revno: 4778
committer: Vladimir 'phcoder' Serbinenko <phcoder-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
branch nick: grub
timestamp: Tue 2013-03-26 11:34:56 +0100
message:
  	* grub-core/kern/efi/mm.c (grub_efi_finish_boot_services):
  	Try terminating EFI services several times due to quirks in some
  	implementations.
diff:
=== modified file 'ChangeLog'
--- ChangeLog	2013-03-26 10:29:52 +0000
+++ ChangeLog	2013-03-26 10:34:56 +0000
@@ -1,3 +1,9 @@
+2013-03-26  Vladimir Serbinenko  <phcoder-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+
+	* grub-core/kern/efi/mm.c (grub_efi_finish_boot_services):
+	Try terminating EFI services several times due to quirks in some
+	implementations.
+
 2013-03-26  Colin Watson  <cjwatson-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
 
 	* grub-core/commands/acpihalt.c (skip_ext_op): Add support for

=== modified file 'grub-core/kern/efi/mm.c'
--- grub-core/kern/efi/mm.c	2013-01-13 01:10:41 +0000
+++ grub-core/kern/efi/mm.c	2013-03-26 10:34:56 +0000
@@ -160,27 +160,41 @@
 			   apple, sizeof (apple)) == 0);
 #endif
 
-  if (grub_efi_get_memory_map (&finish_mmap_size, finish_mmap_buf, &finish_key,
-			       &finish_desc_size, &finish_desc_version) < 0)
-    return grub_error (GRUB_ERR_IO, "couldn't retrieve memory map");
-
-  if (outbuf && *outbuf_size < finish_mmap_size)
-    return grub_error (GRUB_ERR_IO, "memory map buffer is too small");
-
-  finish_mmap_buf = grub_malloc (finish_mmap_size);
-  if (!finish_mmap_buf)
-    return grub_errno;
-
-  if (grub_efi_get_memory_map (&finish_mmap_size, finish_mmap_buf, &finish_key,
-			       &finish_desc_size, &finish_desc_version) <= 0)
-    return grub_error (GRUB_ERR_IO, "couldn't retrieve memory map");
-
-  b = grub_efi_system_table->boot_services;
-  status = efi_call_2 (b->exit_boot_services, grub_efi_image_handle,
-		       finish_key);
-  if (status != GRUB_EFI_SUCCESS)
-    return grub_error (GRUB_ERR_IO, "couldn't terminate EFI services");
-
+  while (1)
+    {
+      if (grub_efi_get_memory_map (&finish_mmap_size, finish_mmap_buf, &finish_key,
+				   &finish_desc_size, &finish_desc_version) < 0)
+	return grub_error (GRUB_ERR_IO, "couldn't retrieve memory map");
+
+      if (outbuf && *outbuf_size < finish_mmap_size)
+	return grub_error (GRUB_ERR_IO, "memory map buffer is too small");
+
+      finish_mmap_buf = grub_malloc (finish_mmap_size);
+      if (!finish_mmap_buf)
+	return grub_errno;
+
+      if (grub_efi_get_memory_map (&finish_mmap_size, finish_mmap_buf, &finish_key,
+				   &finish_desc_size, &finish_desc_version) <= 0)
+	{
+	  grub_free (finish_mmap_buf);
+	  return grub_error (GRUB_ERR_IO, "couldn't retrieve memory map");
+	}
+
+      b = grub_efi_system_table->boot_services;
+      status = efi_call_2 (b->exit_boot_services, grub_efi_image_handle,
+			   finish_key);
+      if (status == GRUB_EFI_SUCCESS)
+	break;
+
+      if (status != GRUB_EFI_INVALID_PARAMETER)
+	{
+	  grub_free (finish_mmap_buf);
+	  return grub_error (GRUB_ERR_IO, "couldn't terminate EFI services");
+	}
+
+      grub_free (finish_mmap_buf);
+      grub_printf ("Trying to terminate EFI services again\n");
+    }
   grub_efi_is_finished = 1;
   if (outbuf_size)
     *outbuf_size = finish_mmap_size;

--=-qKDLrrS1szolY5Edu2H+--
