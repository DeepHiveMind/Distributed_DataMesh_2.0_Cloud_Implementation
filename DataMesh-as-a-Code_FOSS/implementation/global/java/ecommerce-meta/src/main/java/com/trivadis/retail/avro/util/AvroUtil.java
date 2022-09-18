package com.trivadis.retail.avro.util;

import com.trivadis.ecommerce.customer.avro.Customer;
import org.apache.avro.io.*;
import org.apache.avro.specific.SpecificDatumReader;
import org.apache.avro.specific.SpecificDatumWriter;
import org.apache.avro.specific.SpecificRecordBase;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

public class AvroUtil<T extends SpecificRecordBase> {

    public static <T extends SpecificRecordBase> byte[] serialize(T value) throws IOException {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        BinaryEncoder encoder = EncoderFactory.get().binaryEncoder(out, null);
        DatumWriter<T> writer = new SpecificDatumWriter<T>(value.getSchema());

        writer.write(value, encoder);
        encoder.flush();
        return out.toByteArray();
    }

    public static <T extends SpecificRecordBase> T deserialize(byte[] value, Class clazz) throws IOException {
        DatumReader<T> datumReader = new SpecificDatumReader<T>(clazz);
        BinaryDecoder decoder = DecoderFactory.get().binaryDecoder(value, null);
        return datumReader.read(null, decoder);
    }


}
